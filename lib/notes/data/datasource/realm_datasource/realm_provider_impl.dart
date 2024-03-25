import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pwd/common/domain/model/remote_configuration/local_storage_target.dart';
import 'package:pwd/notes/data/datasource/realm_datasource/realm_error_mapper.dart';
import 'package:pwd/notes/data/realm_model/note_item_realm.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:realm/realm.dart';

abstract interface class RealmProvider {
  Future<Realm> getRealm({
    required LocalStorageTarget target,
  });

  Future<Realm> getTempRealm({
    required LocalStorageTarget target,
    required Uint8List bytes,
  });

  Future<void> deleteTempFile(String path);
}

final class RealmProviderImpl implements RealmProvider {
  RealmProviderImpl();

  String? _appDirPath;

  @override
  Future<Realm> getRealm({
    required LocalStorageTarget target,
  }) async {
    final path = await getAppDirPath();
    final filePath = '$path/${target.cacheFileName}';

    return _createRealm(
      target: target,
      path: filePath,
    );
  }

  @override
  Future<Realm> getTempRealm({
    required LocalStorageTarget target,
    required Uint8List bytes,
  }) async {
    final tempFile = await _createTempFile(bytes: bytes, target: target);
    return _createRealm(target: target, path: tempFile.path);
  }

  @override
  Future<void> deleteTempFile(String path) async {
    try {
      await File(path).delete();
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    }
  }
}

// Migrations
extension on RealmProviderImpl {
  void _migration5(Migration migration, int oldSchemaVersion) {
    final now = DateTime.now();
    migration.newRealm.schema.whereType<NoteItemRealm>().forEach(
          (e) => e.updated = TimestampHelper.timestampForDate(now),
        );
  }
}

// Private
extension on RealmProviderImpl {
  Future<File> _createTempFile({
    required Uint8List bytes,
    required LocalStorageTarget target,
  }) async {
    assert(bytes.isNotEmpty, 'Byte array is empty');
    try {
      final tempDirPath = await getTemporaryDirectory().then((e) => e.path);
      final tempRealmPath = '$tempDirPath/${target.cacheTmpFileName}';

      if (await File(tempRealmPath).exists()) {
        await deleteTempFile(tempRealmPath);
      }

      final result = await File(tempRealmPath).writeAsBytes(
        bytes,
        mode: FileMode.writeOnly,
      );

      return result;
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    }
  }

  Realm _createRealm({
    required LocalStorageTarget target,
    required String path,
  }) {
    try {
      const int schemaVersion = 5;
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
          if (schemaVersion == 5) {
            _migration5(migration, oldSchemaVersion);
          } else {
            return;
          }
        },
      );

      final realm = Realm(config);

      if (kDebugMode) {
        print('Realm.config.path: ${realm.config.path}');
      }
      return realm;
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    }
  }
}

// Get app dir path
extension on RealmProviderImpl {
  Future<String> getAppDirPath() async =>
      _appDirPath ??
      await getApplicationDocumentsDirectory().then((e) => e.path);
}
