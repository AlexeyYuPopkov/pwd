import 'package:equatable/equatable.dart';

import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/support/optional_box.dart';

final class ConfigurationScreenData extends Equatable {
  final OptionalBox<ConfigurationScreenDataGit> git;
  final OptionalBox<GoogleDriveConfiguration> googleDrive;
  final RemoteConfigurations _initial;

  final configurationTypes = const [
    ConfigurationType.googleDrive,
    ConfigurationType.git,
  ];

  const ConfigurationScreenData._(
    this._initial, {
    required this.git,
    required this.googleDrive,
  });

  factory ConfigurationScreenData.initial({
    required RemoteConfigurations configurations,
  }) {
    final maybeGit = configurations.withType(ConfigurationType.git);
    final git = (maybeGit is GitConfiguration) ? maybeGit : null;

    final maybeGoogleDrive =
        configurations.withType(ConfigurationType.googleDrive);
    final googleDrive = (maybeGoogleDrive is GoogleDriveConfiguration)
        ? maybeGoogleDrive
        : null;

    return ConfigurationScreenData._(
      configurations,
      git: OptionalBox<ConfigurationScreenDataGit>(
        git == null
            ? null
            : ConfigurationScreenDataGit(
                configuration: git,
                shouldCreateNewFile: false,
              ),
      ),
      googleDrive: OptionalBox(googleDrive),
    );
  }

  @override
  List<Object?> get props => [git, googleDrive];

  RemoteConfigurations createRemoteStorageConfigurations() {
    final git = this.git.data;
    final googleDrive = this.googleDrive.data;

    return RemoteConfigurations(
      configurations: [
        if (googleDrive != null) googleDrive,
        if (git != null) git.configuration,
      ],
    );
  }

  bool get canContinue => createRemoteStorageConfigurations() != _initial;

  bool hasConfiguration(ConfigurationType type) {
    switch (type) {
      case ConfigurationType.git:
        return git.data != null;
      case ConfigurationType.googleDrive:
        return googleDrive.data != null;
    }
  }

  ConfigurationScreenData copyWith({
    OptionalBox<ConfigurationScreenDataGit>? git,
    OptionalBox<GoogleDriveConfiguration>? googleDrive,
  }) {
    return ConfigurationScreenData._(
      _initial,
      git: git ?? this.git,
      googleDrive: googleDrive ?? this.googleDrive,
    );
  }
}

final class ConfigurationScreenDataGit extends Equatable {
  final bool shouldCreateNewFile;
  final GitConfiguration configuration;

  const ConfigurationScreenDataGit({
    required this.shouldCreateNewFile,
    required this.configuration,
  });

  @override
  List<Object?> get props => [shouldCreateNewFile, configuration];
}

final class ConfigurationScreenDataGitBox extends Equatable {
  final ConfigurationScreenDataGit? git;

  const ConfigurationScreenDataGitBox({
    required this.git,
  });

  factory ConfigurationScreenDataGitBox.initial() =>
      const ConfigurationScreenDataGitBox(git: null);

  @override
  List<Object?> get props => [git];
}

final class ConfigurationScreenDataGoogleDriveBox extends Equatable {
  final GoogleDriveConfiguration? googleDrive;

  const ConfigurationScreenDataGoogleDriveBox({
    required this.googleDrive,
  });

  factory ConfigurationScreenDataGoogleDriveBox.initial() =>
      const ConfigurationScreenDataGoogleDriveBox(googleDrive: null);

  @override
  List<Object?> get props => [googleDrive];
}
