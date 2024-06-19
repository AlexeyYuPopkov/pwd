import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pwd/common/domain/model/remote_configuration/local_storage_target.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/data/datasource/realm_datasource/realm_provider/realm_provider.dart';
import 'package:pwd/notes/data/mappers/note_realm_mapper.dart';
import 'package:pwd/notes/data/realm_model/note_item_realm.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'realm_error_mapper.dart';

final class RealmLocalRepositoryImpl implements RealmLocalRepository {
  final RealmProvider realmProvider;

  RealmLocalRepositoryImpl({required this.realmProvider});

  final _changes =
      BehaviorSubject<RealmLocalRepositoryNotification?>.seeded(null);

  void _notify({
    required LocalStorageTarget target,
  }) {
    _changes.sink.add(RealmLocalRepositoryNotification(target: target));
  }

  @override
  Future<void> markDeleted(
    String id, {
    required LocalStorageTarget target,
  }) async {
    final realm = await realmProvider.getRealm(target: target);

    try {
      final obj = realm.find<NoteItemRealm>(id);

      if (obj != null) {
        final now = DateTime.now();
        realm.write(
          () => realm.add(
            obj.deletedCopy(
              timestamp: TimestampHelper.timestampForDate(now),
            ),
            update: true,
          ),
        );
      }
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      realm.close();
      _notify(target: target);
    }
  }

  @override
  Future<void> deleteAll({
    required LocalStorageTarget target,
  }) async {
    final realm = await realmProvider.getRealm(target: target);
    try {
      realm.write(
        () => realm.deleteAll<NoteItemRealm>(),
      );

      assert(realm.all<NoteItemRealm>().isEmpty);
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      realm.close();
      _notify(target: target);
    }
  }

  @override
  Future<void> deleteCacheFile({
    required CacheTarget target,
  }) async =>
      await realmProvider.deleteCacheFileIfPresent(
        target: target,
      );

  @override
  Future<void> saveNotes({
    required LocalStorageTarget target,
    required List<NoteItem> notes,
  }) async {
    final realm = await realmProvider.getRealm(target: target);
    try {
      final items = notes.map((e) => NoteRealmMapper.toData(e));

      realm.write(
        () => realm.addAll(
          items,
          update: true,
        ),
      );
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      realm.close();
      _notify(target: target);
    }
  }

  @override
  Future<NoteItem?> readNote(
    String id, {
    required LocalStorageTarget target,
  }) async {
    final realm = await realmProvider.getRealm(target: target);
    try {
      final obj = realm.find<NoteItemRealm>(id);
      return obj == null ? null : NoteRealmMapper.toDomain(obj);
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      realm.close();
    }
  }

  @override
  Future<List<NoteItem>> readNotes({
    required LocalStorageTarget target,
  }) async {
    final realm = await realmProvider.getRealm(target: target);
    try {
      return realm
          .all<NoteItemRealm>()
          .where((e) {
            return e.isDeleted == null || e.isDeleted == false;
          })
          .map((e) => NoteRealmMapper.toDomain(e))
          .toList();
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      realm.close();
    }
  }

  @override
  Future<void> updateNote(
    UpdatedNoteItem noteItem, {
    required LocalStorageTarget target,
  }) async {
    final realm = await realmProvider.getRealm(target: target);
    try {
      realm.write(
        () => realm.add(
          NoteRealmMapper.toData(noteItem),
          update: true,
        ),
      );
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      realm.close();
      _notify(target: target);
    }
  }

  @override
  Future<void> createNote(
    NewNoteItem noteItem, {
    required LocalStorageTarget target,
  }) async {
    final realm = await realmProvider.getRealm(target: target);
    try {
      realm.write(
        () {
          final deleted =
              realm.query<NoteItemRealm>('isDeleted == true').firstOrNull;

          final updated = deleted == null
              ? NoteRealmMapper.toData(noteItem)
              : NoteRealmMapper.toData(
                  NoteRealmMapper.toDomain(deleted).copyWith(
                    content: noteItem.content,
                  ),
                );

          return realm.add(
            updated,
            update: true,
          );
        },
      );
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      realm.close();
      _notify(target: target);
    }
  }

  @override
  Future<Uint8List> readAsBytes({
    required LocalStorageTarget target,
  }) async {
    final realm = await realmProvider.getRealm(target: target).then(
          (e) => e.freeze(),
        );
    try {
      return File(realm.config.path).readAsBytes();
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      realm.close();
    }
  }

  @override
  Future<void> mergeWithDatabasePath({
    required Uint8List bytes,
    required LocalStorageTarget target,
  }) async {
    try {
      await _mergeWithDatabasePath(
        bytes: bytes,
        target: target,
      );
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      _notify(target: target);
    }
  }

  @override
  Stream<RealmLocalRepositoryNotification?> getChangesStream() {
    return _changes;
  }
}

// Merge
extension _Migration on RealmLocalRepositoryImpl {
  Future<void> _mergeWithDatabasePath({
    required Uint8List bytes,
    required LocalStorageTarget target,
  }) async {
    await realmProvider.deleteTempFolderIfPresent(target: target);

    final realm = await realmProvider.getRealm(target: target);
    assert(realm.config.path.isNotEmpty);
    final tempRealm = await realmProvider.getTempRealm(
      target: target,
      bytes: bytes,
    );

    try {
      await realm.writeAsync(
        () {
          final toAdd = tempRealm.all<NoteItemRealm>().map(
            (tempItem) {
              final localItem = realm.find<NoteItemRealm>(tempItem.id);

              if (localItem != null && localItem.updated >= tempItem.updated) {
                return localItem;
              } else {
                return NoteItemRealm(
                  tempItem.id,
                  tempItem.updated,
                  tempItem.body,
                  isDeleted: tempItem.isDeleted,
                );
              }
            },
          );

          realm.addAll<NoteItemRealm>(
            toAdd,
            update: true,
          );
        },
      );
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      tempRealm.close();
      realm.close();
      await realmProvider.deleteTempFolderIfPresent(target: target);
    }
  }
}
