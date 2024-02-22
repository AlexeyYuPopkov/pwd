import 'package:equatable/equatable.dart';

final class RemoteStorageConfigurations extends Equatable {
  final List<RemoteStorageConfiguration> configurations;
  late final Map<ConfigurationType, int> _configurationIndexes;

  RemoteStorageConfigurations({required this.configurations}) {
    var configurationIndexes = <ConfigurationType, int>{};
    for (int i = 0; i < configurations.length; i++) {
      configurationIndexes[configurations[i].type] = i;
    }

    _configurationIndexes = configurationIndexes;

    assert(Set.from(configurations).length == configurations.length);
  }

  factory RemoteStorageConfigurations.empty() =>
      RemoteStorageConfigurations(configurations: const []);

  bool get isNotEmpty => configurations.isNotEmpty;
  bool get isEmpty => configurations.isEmpty;

  bool hasConfiguration(ConfigurationType type) => withType(type) != null;

  @override
  List<Object?> get props => [configurations];

  RemoteStorageConfiguration? withType(ConfigurationType type) {
    final index = _configurationIndexes[type];

    if (index == null) {
      return null;
    }

    final idValidIndex = index >= 0 && index < configurations.length;
    assert(idValidIndex);

    return idValidIndex ? configurations[index] : null;
  }

  RemoteStorageConfigurations copyRemovedType(ConfigurationType type) {
    final index = _configurationIndexes[type];

    if (index is! int) {
      return this;
    }
    assert(index >= 0 && index < configurations.length);
    if (index >= 0 && index < configurations.length) {
      var newConfigurations = configurations;
      newConfigurations.removeAt(index);

      return RemoteStorageConfigurations(
        configurations: newConfigurations,
      );
    } else {
      return this;
    }
  }

  RemoteStorageConfigurations copyAppendedType(
    RemoteStorageConfiguration configuration,
  ) =>
      hasConfiguration(configuration.type)
          ? this
          : RemoteStorageConfigurations(
              configurations: [
                ...configurations,
                configuration,
              ],
            );
}

enum ConfigurationType {
  git,
  googleDrive,
}

sealed class RemoteStorageConfiguration extends Equatable {
  const RemoteStorageConfiguration();

  const factory RemoteStorageConfiguration.git({
    required String token,
    required String repo,
    required String owner,
    required String? branch,
    required String fileName,
  }) = GitConfiguration;

  const factory RemoteStorageConfiguration.google({
    required String fileName,
  }) = GoogleDriveConfiguration;

  ConfigurationType get type;
}

final class GitConfiguration extends RemoteStorageConfiguration {
  @override
  final type = ConfigurationType.git;

  final String token;
  final String repo;
  final String owner;
  String? get branch => _branch?.trim().isNotEmpty == true ? _branch : null;
  final String fileName;
  final String? _branch;

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
      ];
}

final class GoogleDriveConfiguration extends RemoteStorageConfiguration {
  @override
  final type = ConfigurationType.googleDrive;

  final String fileName;
  final String realmFileName = 'realm_migration';

  const GoogleDriveConfiguration({
    required this.fileName,
  });

  @override
  List<Object?> get props => [
        fileName,
        realmFileName,
      ];
}
