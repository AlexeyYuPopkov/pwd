abstract class RemoteStorageConfiguration {
  const RemoteStorageConfiguration();
  String get token;
  String get repo;
  String get owner;
  String? get branch;
  String get fileName;

  const factory RemoteStorageConfiguration.empty() =
      RemoteStorageConfigurationEmpty;

  const factory RemoteStorageConfiguration.configuration({
    required String token,
    required String repo,
    required String owner,
    required String? branch,
    required String fileName,
  }) = ValidConfiguration;

  @override
  bool operator ==(Object other) => other.hashCode == hashCode;

  @override
  int get hashCode => Object.hashAll({token, repo, owner, fileName});
}

class RemoteStorageConfigurationEmpty extends RemoteStorageConfiguration {
  @override
  String get fileName => '';

  @override
  String get owner => '';

  @override
  String get repo => '';

  @override
  String get token => '';

  @override
  String? get branch => null;

  const RemoteStorageConfigurationEmpty();
}

class ValidConfiguration extends RemoteStorageConfiguration {
  @override
  final String token;
  @override
  final String repo;
  @override
  final String owner;
  @override
  final String? branch;
  @override
  final String fileName;

  const ValidConfiguration({
    required this.token,
    required this.repo,
    required this.owner,
    required this.branch,
    required this.fileName,
  });
}
