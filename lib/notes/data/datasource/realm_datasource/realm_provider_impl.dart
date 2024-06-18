import 'dart:async';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pwd/common/domain/model/remote_configuration/local_storage_target.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
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

  Future<void> deleteCacheFile({
    required CacheTarget target,
  });

  Future<void> deleteTempFile({
    required CacheTarget target,
  });
}

final class StorageDirectoryPathProvider {
  String? _appDirPath;

  Future<String> getAppDirPath() async {
    return _appDirPath ??
        await getApplicationDocumentsDirectory().then((e) {
          return e.path;
        });
  }
}

final class RealmProviderImpl implements RealmProvider {
  final FileSystem fileSystem;
  final storage = StorageDirectoryPathProvider();

  RealmProviderImpl([
    this.fileSystem = const LocalFileSystem(),
  ]);

  @override
  Future<Realm> getRealm({
    required LocalStorageTarget target,
  }) async =>
      createRealm(
        parameters: CreateRealmConfigParameters.cache(target: target),
      );

  @override
  Future<Realm> getTempRealm({
    required LocalStorageTarget target,
    required Uint8List bytes,
  }) async =>
      createRealm(
        parameters:
            CreateRealmConfigParameters.tmp(target: target, bytes: bytes),
      );

  @override
  Future<void> deleteCacheFile({
    required CacheTarget target,
  }) async {
    try {
      final path = await _getRealmFilePath(target: target);
      final file = fileSystem.file(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    }
  }

  @override
  Future<void> deleteTempFile({required CacheTarget target}) async {
    try {
      final folderPath = await _getRealmTempFileFolderPath(target: target);
      final folder = fileSystem.directory(folderPath);
      if (await folder.exists()) {
        await folder.delete(recursive: true);
      }
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    }
  }

  Future<String> _getRealmFilePath({
    required CacheTarget target,
  }) async {
    final path = await storage.getAppDirPath();
    return '$path/${target.fileName}';
  }

  Future<String> _getRealmTempFilePath({
    required CacheTarget target,
  }) async {
    final path = await _getRealmTempFileFolderPath(target: target);
    return '$path/${target.cacheTmpFileName}';
  }

  Future<String> _getRealmTempFileFolderPath({
    required CacheTarget target,
  }) async {
    final path = await storage.getAppDirPath();
    return '$path/${target.cacheTmpFileName}';
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
      final tempRealmDirPath =
          await _getRealmTempFileFolderPath(target: target);
      final dir = fileSystem.directory(tempRealmDirPath);

      if (await dir.exists()) {
        dir.delete(recursive: true);
      }

      await dir.create(recursive: true);

      final tempRealmPath = await _getRealmTempFilePath(target: target);

      final result = await fileSystem.file(tempRealmPath).writeAsBytes(
            bytes,
            mode: FileMode.writeOnly,
          );

      return result;
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    }
  }
}

extension CreateRealmConfig on RealmProviderImpl {
  Future<String> _createRealmConfigPath({
    required CreateRealmConfigParameters parameters,
  }) {
    switch (parameters) {
      case CreateRealmConfigParametersCache():
        return _getRealmFilePath(target: parameters.target);
      case CreateRealmConfigParametersTemp():
        return _createTempFile(
                bytes: parameters.bytes, target: parameters.target)
            .then(
          (e) => e.path,
        );
    }
  }

  Future<Configuration> _createRealmConfig({
    required CreateRealmConfigParameters parameters,
  }) async {
    try {
      const int schemaVersion = 5;

      final path = await _createRealmConfigPath(parameters: parameters);

      final notInMemory = fileSystem is LocalFileSystem;

      final List<SchemaObject> schemaObjects = [
        NoteItemRealm.schema,
        NoteItemContentRealm.schema,
      ];

      final result = notInMemory
          ? Configuration.local(
              schemaObjects,
              encryptionKey: parameters.target.key,
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
            )
          : Configuration.inMemory(
              schemaObjects,
              path: path,
            );

      return result;
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    }
  }

  Future<Realm> createRealm({
    required CreateRealmConfigParameters parameters,
  }) async {
    try {
      final config = await _createRealmConfig(parameters: parameters);

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

// CreateRealmConfigParameters
sealed class CreateRealmConfigParameters {
  const CreateRealmConfigParameters();
  bool get isReadOnly;
  LocalStorageTarget get target;

  const factory CreateRealmConfigParameters.cache({
    required LocalStorageTarget target,
  }) = CreateRealmConfigParametersCache._;

  factory CreateRealmConfigParameters.tmp({
    required LocalStorageTarget target,
    required Uint8List bytes,
  }) = CreateRealmConfigParametersTemp._;
}

final class CreateRealmConfigParametersCache
    extends CreateRealmConfigParameters {
  const CreateRealmConfigParametersCache._({required this.target});

  @override
  final LocalStorageTarget target;

  @override
  bool get isReadOnly => false;
}

final class CreateRealmConfigParametersTemp
    extends CreateRealmConfigParameters {
  @override
  final LocalStorageTarget target;

  final Uint8List bytes;

  CreateRealmConfigParametersTemp._({
    required this.target,
    required this.bytes,
  }) {
    assert(bytes.isNotEmpty);
  }

  @override
  bool get isReadOnly => true;
}
