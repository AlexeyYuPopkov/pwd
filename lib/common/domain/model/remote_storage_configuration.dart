import 'package:equatable/equatable.dart';

final class RemoteStorageConfigurations extends Equatable {
  RemoteStorageConfigurations({required this.configurations})
      : assert(Set.from(configurations).length == configurations.length);

  @override
  List<Object?> get props => [configurations];

  final List<RemoteStorageConfiguration> configurations;

  bool get isValid => configurations.isNotEmpty;

  factory RemoteStorageConfigurations.empty() =>
      RemoteStorageConfigurations(configurations: const []);
}

sealed class RemoteStorageConfiguration extends Equatable {
  const RemoteStorageConfiguration();

  // const factory RemoteStorageConfiguration.empty() =
  //     RemoteStorageConfigurationEmpty;

  const factory RemoteStorageConfiguration.git({
    required String token,
    required String repo,
    required String owner,
    required String? branch,
    required String fileName,
  }) = GitConfiguration;

  const factory RemoteStorageConfiguration.google({
    required String filename,
  }) = GoogleDriveConfiguration;
}

// final class RemoteStorageConfigurationEmpty extends RemoteStorageConfiguration {
//   const RemoteStorageConfigurationEmpty();

//   @override
//   List<Object?> get props => [];
// }

final class GitConfiguration extends RemoteStorageConfiguration {
  final String token;
  final String repo;
  final String owner;
  String? get branch => _branch?.trim().isNotEmpty == true ? _branch : null;
  final String fileName;
  final String? _branch;
  final String realmFileName = 'realm_migration';

  const GitConfiguration({
    required this.token,
    required this.repo,
    required this.owner,
    required String? branch,
    required this.fileName,
  }) : _branch = branch;

  @override
  List<Object?> get props => [
        token,
        repo,
        owner,
        branch,
        branch,
        realmFileName,
      ];
}

final class GoogleDriveConfiguration extends RemoteStorageConfiguration {
  final String filename;
  final String realmFileName = 'realm_migration';

  const GoogleDriveConfiguration({
    required this.filename,
  });

  @override
  List<Object?> get props => [
        filename,
        realmFileName,
      ];
}
