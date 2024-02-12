import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/notes/data/mappers/note_realm_mapper.dart';
import 'package:pwd/notes/data/realm_model/note_item_realm.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/local_storage_error.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';

final class RealmDatasourceImpl implements RealmLocalRepository {
  static const _tempFileMame = 'temp.realm';
  Realm? realm;
  Realm? realmDecrypted;

  @override
  Future<void> close() async => realm?.close();

  @override
  Future<void> delete(String id, {required List<int>? key}) async {
    try {
      final realm = _getRealm(key: key);

      final obj = realm.find<NoteItemRealm>(id);

      if (obj != null) {
        realm.write(() {
          realm.delete(obj);
        });
      }
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    }
  }

  @override
  Future<void> deleteAll({required List<int>? key}) async {
    try {
      final realm = _getRealm(key: key);

      realm.write(
        () => realm.deleteAll<NoteItemRealm>(),
      );

      assert(realm.all<NoteItemRealm>().isEmpty);
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    }
  }

  @override
  Future<void> saveNotes({
    required List<int>? key,
    required List<NoteItem> notes,
  }) async {
    try {
      final realm = _getRealm(key: key);
      final items = notes.map((e) => NoteRealmMapper.toData(e));

      realm.write(
        () => realm.addAll(
          items,
          update: true,
        ),
      );
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    }
  }

  @override
  Future<NoteItem?> readNote(
    String id, {
    required List<int>? key,
  }) async {
    try {
      final realm = _getRealm(key: key);
      final obj = realm.find<NoteItemRealm>(id);
      return obj == null ? null : NoteRealmMapper.toDomain(obj);
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    }
  }

  @override
  Future<List<NoteItem>> readNotes({
    required List<int>? key,
  }) async {
    try {
      final realm = _getRealm(key: key);
      return realm
          .all<NoteItemRealm>()
          .map((e) => NoteRealmMapper.toDomain(e))
          .toList();
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    }
  }

  @override
  Future<void> updateNote(
    NoteItem noteItem, {
    required List<int>? key,
  }) async {
    try {
      final realm = _getRealm(key: key);

      realm.write(
        () => realm.add(
          NoteRealmMapper.toData(noteItem),
          update: true,
        ),
      );
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    }
  }

  @override
  Future<Uint8List> readAsBytes({required List<int>? key}) async {
    try {
      final realm = _getRealm(key: key);
      return File(realm.config.path).readAsBytes();
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    }
  }

  @override
  Future<void> migrateWithDatabasePath({
    required Uint8List bytes,
    required List<int>? key,
    required Set<String> deleted,
  }) async {
    try {
      return _migrateWithDatabasePath(
        bytes: bytes,
        key: key,
        deleted: deleted,
      );
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    }
  }

  Future<void> _migrateWithDatabasePath({
    required Uint8List bytes,
    required List<int>? key,
    required Set<String> deleted,
  }) async {
    assert(bytes.isNotEmpty);

    final realm = _getRealm(key: key);

    final realmPath = realm.config.path;
    assert(realmPath.isNotEmpty);

    final tempDirPath = await getTemporaryDirectory().then((e) => e.path);
    final tempRealmPath = '$tempDirPath/$_tempFileMame';

    final tempRealmFile = await File(tempRealmPath).writeAsBytes(bytes);

    final tempRealm = _createRealm(key: key, path: tempRealmPath);

    await realm.writeAsync(
      () {
        realm.addAll<NoteItemRealm>(
          tempRealm.all<NoteItemRealm>().map(
            (p) {
              final localItem = realm.find<NoteItemRealm>(p.id);

              if (localItem != null && localItem.timestamp > p.timestamp) {
                return localItem;
              } else {
                return NoteItemRealm(
                  p.id,
                  p.title,
                  p.description,
                  p.timestamp,
                  content: p.content.map((e) => NoteItemContentRealm(e.text)),
                );
              }
            },
          ),
          update: true,
        );

        final itemsToRemove = realm.all<NoteItemRealm>().where(
          (e) {
            return deleted.contains(e.id) || e.id.isEmpty;
          },
        );

        realm.deleteMany(itemsToRemove);
      },
    );

    tempRealm.close();

    await tempRealmFile.delete();
  }
}

extension on RealmDatasourceImpl {
  Realm _getRealm({required List<int>? key}) =>
      realm ??= _createRealm(key: key);

  Realm _createRealm({required List<int>? key, String? path}) {
    final config = Configuration.local(
      [
        NoteItemRealm.schema,
        NoteItemContentRealm.schema,
      ],
      encryptionKey: key,
      path: path,
    );

    final realm = Realm(config);

    if (kDebugMode) {
      print('Realm.config.path: ${realm.config.path}');
    }
    return realm;
  }
}

final class _ErrorMapper {
  static AppError toDomain(Object e) {
    if (e is RealmException &&
        e.message.contains('Realm file decryption failed')) {
      return LocalStorageError.pinDoesNotMatch(parentError: e);
    } else {
      return LocalStorageError.unknown(parentError: e);
    }
  }
}
