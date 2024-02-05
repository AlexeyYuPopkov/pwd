import 'package:equatable/equatable.dart';

import 'package:pwd/common/domain/model/remote_storage_configuration.dart';

final class ConfigurationScreenData extends Equatable {
  final ConfigurationScreenDataGitBox git;
  final ConfigurationScreenDataGoogleDriveBox googleDrive;

  final configurationTypes = const [
    ConfigurationType.googleDrive,
    ConfigurationType.git,
  ];

  const ConfigurationScreenData._({
    required this.git,
    required this.googleDrive,
  });

  factory ConfigurationScreenData.initial() => ConfigurationScreenData._(
        git: ConfigurationScreenDataGitBox.initial(),
        googleDrive: ConfigurationScreenDataGoogleDriveBox.initial(),
      );

  @override
  List<Object?> get props => [git, googleDrive];

  bool get canContinue =>
      hasConfiguration(ConfigurationType.git) ||
      hasConfiguration(ConfigurationType.googleDrive);

  bool hasConfiguration(ConfigurationType type) {
    switch (type) {
      case ConfigurationType.git:
        return git.git != null;
      case ConfigurationType.googleDrive:
        return googleDrive.googleDrive != null;
    }
  }

  ConfigurationScreenData copyWith({
    ConfigurationScreenDataGitBox? git,
    ConfigurationScreenDataGoogleDriveBox? googleDrive,
  }) {
    return ConfigurationScreenData._(
      git: git ?? this.git,
      googleDrive: googleDrive ?? this.googleDrive,
    );
  }
}

final class ConfigurationScreenDataGit {
  final bool shouldCreateNewFile;
  final GitConfiguration configuration;

  const ConfigurationScreenDataGit({
    required this.shouldCreateNewFile,
    required this.configuration,
  });
}

final class ConfigurationScreenDataGitBox {
  final ConfigurationScreenDataGit? git;

  const ConfigurationScreenDataGitBox({
    required this.git,
  });

  factory ConfigurationScreenDataGitBox.initial() =>
      const ConfigurationScreenDataGitBox(git: null);
}

final class ConfigurationScreenDataGoogleDriveBox {
  final GoogleDriveConfiguration? googleDrive;

  const ConfigurationScreenDataGoogleDriveBox({
    required this.googleDrive,
  });

  factory ConfigurationScreenDataGoogleDriveBox.initial() =>
      const ConfigurationScreenDataGoogleDriveBox(googleDrive: null);
}
