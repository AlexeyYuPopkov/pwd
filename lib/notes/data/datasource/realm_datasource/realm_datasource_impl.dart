import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pwd/common/domain/model/remote_configuration/local_storage_target.dart';
import 'package:pwd/notes/data/mappers/note_realm_mapper.dart';
import 'package:pwd/notes/data/realm_model/note_item_realm.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';

import 'realm_error_mapper.dart';
import 'realm_provider_impl.dart';

const _validTillDuration = Duration(days: 120);

final class RealmDatasourceImpl implements RealmLocalRepository {
  final RealmProvider realmProvider;

  const RealmDatasourceImpl({required this.realmProvider});

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
        realm.write(() {
          realm.add(
            obj.deletedCopy(
              timestamp: TimestampHelper.timestampForDate(now),
              deletedTimestamp: TimestampHelper.timestampForDateAppending(
                now,
                _validTillDuration,
              ),
            ),
            update: true,
          );
        });
      }
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      realm.close();
    }
  }

  @override
  Future<void> creanDeletedIfNeeded({
    required LocalStorageTarget target,
  }) async {
    final realm = await realmProvider.getRealm(target: target);
    try {
      final timestamp = TimestampHelper.timestampForDate(DateTime.now());
      final items = realm.all<NoteItemRealm>().where((e) {
        return e.deletedTimestamp != null && e.deletedTimestamp! < timestamp;
      });

      if (items.isNotEmpty) {
        debugger();
        realm.write(
          () => realm.deleteMany(items),
        );
      }
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      realm.close();
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
    }
  }

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
            return e.deletedTimestamp == null;
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
    BaseNoteItem noteItem, {
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
      return _mergeWithDatabasePath(
        bytes: bytes,
        target: target,
      );
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    }
  }
}

// Merge
extension _Migration on RealmDatasourceImpl {
  Future<void> _mergeWithDatabasePath({
    required Uint8List bytes,
    required LocalStorageTarget target,
  }) async {
    final realm = await realmProvider.getRealm(target: target);
    assert(realm.config.path.isNotEmpty);
    final tempRealm = await realmProvider.getTempRealm(
      target: target,
      bytes: bytes,
    );

    try {
      await realm.writeAsync(
        () {
          realm.addAll<NoteItemRealm>(
            tempRealm.all<NoteItemRealm>().map(
              (p) {
                final localItem = realm.find<NoteItemRealm>(p.id);

                // debugger();
                // print(
                //   "local timestamp: ${localItem?.timestamp ?? -1}, remote timestamp: ${p.timestamp},",
                // );

                if (localItem != null && localItem.updated >= p.updated) {
                  return localItem;
                } else {
                  return NoteItemRealm(
                    p.id,
                    p.title,
                    p.description,
                    p.updated,
                    deletedTimestamp: p.deletedTimestamp,
                    content: p.content.map((e) => NoteItemContentRealm(e.text)),
                  );
                }
              },
            ),
            update: true,
          );
        },
      );
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    } finally {
      tempRealm.close();
      realm.close();
      await realmProvider.deleteTempFile(tempRealm.config.path);
    }
  }
}
