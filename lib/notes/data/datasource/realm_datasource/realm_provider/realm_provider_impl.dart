import 'dart:async';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pwd/common/domain/model/remote_configuration/local_storage_target.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/data/datasource/realm_datasource/realm_error_mapper.dart';
import 'package:pwd/notes/data/mappers/note_realm_mapper.dart';
import 'package:pwd/notes/data/realm_model/note_item_realm.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:realm/realm.dart';

import 'create_realm_config_parameters.dart';
import 'realm_provider.dart';

part 'realm_provider_impl_create_realm_part.dart';
part 'realm_provider_impl_migrations_part.dart';

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
        parameters: CreateRealmConfigParameters.tmp(
          target: target,
          bytes: bytes,
        ),
      );

  @override
  Future<void> deleteCacheFileIfPresent({
    required CacheTarget target,
  }) async {
    try {
      final path = await target._getRealmFilePath(storage: storage);
      final file = fileSystem.file(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    }
  }

  @override
  Future<void> deleteTempFolderIfPresent({required CacheTarget target}) async {
    try {
      final folderPath =
          await target._getRealmTempFileFolderPath(storage: storage);
      final folder = fileSystem.directory(folderPath);
      if (await folder.exists()) {
        await folder.delete(recursive: true);
      }
    } catch (e) {
      throw RealmErrorMapper.toDomain(e);
    }
  }
}
