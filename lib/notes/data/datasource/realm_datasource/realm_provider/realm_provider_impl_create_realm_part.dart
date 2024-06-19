part of 'realm_provider_impl.dart';

extension RealmProviderCreateRealmConfigPath on RealmProviderImpl {
  Future<String> createRealmConfigPath({
    required CreateRealmConfigParameters parameters,
  }) {
    switch (parameters) {
      case CreateRealmConfigParametersCache():
        return parameters.target._getRealmFilePath(storage: storage);
      case CreateRealmConfigParametersTemp():
        return _createTempFile(
          bytes: parameters.bytes,
          target: parameters.target,
        ).then(
          (e) => e.path,
        );
    }
  }

  Future<Configuration> _createRealmConfig({
    required CreateRealmConfigParameters parameters,
  }) async {
    try {
      const int schemaVersion = 6;

      final path = await createRealmConfigPath(parameters: parameters);

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
                }

                if (oldSchemaVersion < 6) {
                  _migration6(migration, oldSchemaVersion);
                }

                //   if (oldSchemaVersion < 7) {
                //   _migration7(migration, oldSchemaVersion);
                // }
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

// Private
extension on RealmProviderImpl {
  Future<File> _createTempFile({
    required Uint8List bytes,
    required LocalStorageTarget target,
  }) async {
    assert(bytes.isNotEmpty, 'Byte array is empty');
    try {
      final tempRealmDirPath = await target._getRealmTempFileFolderPath(
        storage: storage,
      );
      final dir = fileSystem.directory(tempRealmDirPath);

      if (await dir.exists()) {
        dir.delete(recursive: true);
      }

      await dir.create(recursive: true);

      final tempRealmPath =
          await target._getRealmTempFilePath(storage: storage);

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

// Pathes
extension on CacheTarget {
  Future<String> _getRealmFilePath({
    required StorageDirectoryPathProvider storage,
  }) async {
    final path = await storage.getAppDirPath();
    return '$path/$fileName';
  }

  Future<String> _getRealmTempFilePath({
    required StorageDirectoryPathProvider storage,
  }) async {
    final path = await _getRealmTempFileFolderPath(storage: storage);
    return '$path/$cacheTmpFileName';
  }

  Future<String> _getRealmTempFileFolderPath({
    required StorageDirectoryPathProvider storage,
  }) async {
    final path = await storage.getAppDirPath();
    return '$path/$cacheTmpFileName';
  }
}
