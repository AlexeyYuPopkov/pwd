import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pwd/common/domain/model/remote_configuration/local_storage_target.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/notes/data/mappers/note_realm_mapper.dart';
import 'package:pwd/notes/data/realm_model/note_item_realm.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/local_storage_error.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';

const _validTillDuration = Duration(days: 120);

final class RealmDatasourceImpl implements RealmLocalRepository {
  String? _appDirPath;

  Future<String> getAppDirPath() async =>
      _appDirPath ??
      await getApplicationDocumentsDirectory().then((e) => e.path);

  @override
  Future<void> markDeleted(
    String id, {
    required LocalStorageTarget target,
  }) async {
    final realm = await _getRealm(target: target);

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
      throw _ErrorMapper.toDomain(e);
    } finally {
      realm.close();
    }
  }

  @override
  Future<void> creanDeletedIfNeeded({
    required LocalStorageTarget target,
  }) async {
    final realm = await _getRealm(target: target);
    try {
      final timestamp = TimestampHelper.timestampForDate(DateTime.now());
      final items = realm.all<NoteItemRealm>().where((e) {
        return e.deletedTimestamp != null && e.deletedTimestamp! < timestamp;
      });

      if (items.isNotEmpty) {
        realm.write(
          () => realm.deleteMany(items),
        );
      }
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    } finally {
      realm.close();
    }
  }

  @override
  Future<void> deleteAll({
    required LocalStorageTarget target,
  }) async {
    final realm = await _getRealm(target: target);
    try {
      realm.write(
        () => realm.deleteAll<NoteItemRealm>(),
      );

      assert(realm.all<NoteItemRealm>().isEmpty);
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    } finally {
      realm.close();
    }
  }

  @override
  Future<void> saveNotes({
    required LocalStorageTarget target,
    required List<NoteItem> notes,
  }) async {
    final realm = await _getRealm(target: target);
    try {
      final items = notes.map((e) => NoteRealmMapper.toData(e));

      realm.write(
        () => realm.addAll(
          items,
          update: true,
        ),
      );
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    } finally {
      realm.close();
    }
  }

  @override
  Future<NoteItem?> readNote(
    String id, {
    required LocalStorageTarget target,
  }) async {
    final realm = await _getRealm(target: target);
    try {
      final obj = realm.find<NoteItemRealm>(id);
      return obj == null ? null : NoteRealmMapper.toDomain(obj);
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    } finally {
      realm.close();
    }
  }

  @override
  Future<List<NoteItem>> readNotes({
    required LocalStorageTarget target,
  }) async {
    final realm = await _getRealm(target: target);
    try {
      return realm
          .all<NoteItemRealm>()
          .where((e) => e.deletedTimestamp == null)
          .map((e) => NoteRealmMapper.toDomain(e))
          .toList();
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    } finally {
      realm.close();
    }
  }

  @override
  Future<void> updateNote(
    BaseNoteItem noteItem, {
    required LocalStorageTarget target,
  }) async {
    final realm = await _getRealm(target: target);
    try {
      realm.write(
        () => realm.add(
          NoteRealmMapper.toData(noteItem),
          update: true,
        ),
      );
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    } finally {
      realm.close();
    }
  }

  @override
  Future<Uint8List> readAsBytes({
    required LocalStorageTarget target,
  }) async {
    final realm = await _getRealm(target: target);
    try {
      return File(realm.config.path).readAsBytes();
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
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
      throw _ErrorMapper.toDomain(e);
    }
  }
}

// Merge
extension _Migration on RealmDatasourceImpl {
  Future<void> _mergeWithDatabasePath({
    required Uint8List bytes,
    required LocalStorageTarget target,
  }) async {
    final realm = await _getRealm(target: target);
    assert(realm.config.path.isNotEmpty);
    final tempFile = await _createTempFile(bytes: bytes, target: target);
    final tempRealm = _getTempRealm(target: target, path: tempFile.path);

    try {
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
      throw _ErrorMapper.toDomain(e);
    } finally {
      tempRealm.close();
      realm.close();
      await _deleteTempFile(tempFile);
    }
  }
}

// Create realm
extension _CreateRealm on RealmDatasourceImpl {
  Future<Realm> _getRealm({
    required LocalStorageTarget target,
  }) async {
    final path = await getAppDirPath();
    return _createRealm(
      target: target,
      path: '$path/${target.cacheFileName}',
    );
  }

  Realm _getTempRealm({
    required LocalStorageTarget target,
    required String path,
  }) =>
      _createRealm(
        target: target,
        path: path,
      );

  Realm _createRealm({
    required LocalStorageTarget target,
    required String path,
  }) {
    try {
      const int schemaVersion = 3;
      final config = Configuration.local(
        [
          NoteItemRealm.schema,
          NoteItemContentRealm.schema,
        ],
        encryptionKey: target.key,
        path: path,
        schemaVersion: schemaVersion,
        migrationCallback: (migration, oldSchemaVersion) {
          if (schemaVersion == oldSchemaVersion) {
            return;
          }
          if (schemaVersion == 3) {
            _from2to3Migration(migration, oldSchemaVersion);
          }
        },
      );

      final realm = Realm(config);

      if (kDebugMode) {
        print('Realm.config.path: ${realm.config.path}');
      }
      return realm;
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    }
  }

  void _from2to3Migration(Migration migration, int oldSchemaVersion) =>
      migration.newRealm.schema.whereType<NoteItemRealm>().forEach(
            (e) => e.deletedTimestamp = null,
          );

  Future<File> _createTempFile({
    required Uint8List bytes,
    required LocalStorageTarget target,
  }) async {
    assert(bytes.isNotEmpty, 'Byte array is empty');
    try {
      final tempDirPath = await getTemporaryDirectory().then((e) => e.path);
      final tempRealmPath = '$tempDirPath/${target.cacheTmpFileName}';
      final result = await File(tempRealmPath).writeAsBytes(bytes);

      return result;
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    }
  }

  Future<void> _deleteTempFile(File tempFile) async {
    try {
      await tempFile.delete();
    } catch (e) {
      throw _ErrorMapper.toDomain(e);
    }
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
