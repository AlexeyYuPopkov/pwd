sealed class RemoteStorageConfiguration {
  const RemoteStorageConfiguration();
  String get token;
  String get repo;
  String get owner;
  String? get branch;
  String get fileName;
  String get realmFileName;

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

  @override
  String toString() {
    return 'type: $runtimeType\n'
        'token: $token\n'
        'repo: $repo\n'
        'owner: $owner\n'
        'branch: $branch\n'
        'fileName: $fileName\n';
  }
}

final class RemoteStorageConfigurationEmpty extends RemoteStorageConfiguration {
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

  @override
  String get realmFileName => '';
}

final class ValidConfiguration extends RemoteStorageConfiguration {
  @override
  final String token;
  @override
  final String repo;
  @override
  final String owner;
  @override
  String? get branch => _branch?.trim().isNotEmpty == true ? _branch : null;

  @override
  final String fileName;

  final String? _branch;

  @override
  final String realmFileName = 'realm_migration';

  const ValidConfiguration({
    required this.token,
    required this.repo,
    required this.owner,
    required String? branch,
    required this.fileName,
  }) : _branch = branch;
}
