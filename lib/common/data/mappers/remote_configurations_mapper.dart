import 'package:pwd/common/data/model/git_configuration_data.dart';
import 'package:pwd/common/data/model/google_drive_configuration_data.dart';
import 'package:pwd/common/data/model/remote_storage_configurations_data.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';

final class RemoteConfigurationsMapper {
  static RemoteStorageConfigurationsData toData(
    RemoteConfigurations src,
  ) =>
      RemoteStorageConfigurationsData(
        configurations: [
          for (final item in src.configurations) _createConfigurationBox(item),
        ],
      );

  static RemoteStorageConfigurationBox _createConfigurationBox(
    RemoteConfiguration src,
  ) {
    switch (src) {
      case GitConfiguration():
        return RemoteStorageConfigurationBox(
          type: RemoteConfigurationTypeData.git,
          value: GitConfigurationData(
            token: src.token,
            repo: src.repo,
            owner: src.owner,
            branch: src.branch,
            fileName: src.fileName,
          ),
        );
      case GoogleDriveConfiguration():
        return RemoteStorageConfigurationBox(
          type: RemoteConfigurationTypeData.googleDrive,
          value: GoogleDriveConfigurationData(
            fileName: src.fileName,
          ),
        );
    }
  }

  static RemoteConfigurations toDomain(
    RemoteStorageConfigurationsData src,
  ) {
    return RemoteConfigurations.createOrThrow(
      configurations: [
        for (final item in src.configurations)
          _createConfigurationFromBox(item),
      ].whereType<RemoteConfiguration>().toList(),
    );
  }

  static RemoteConfiguration? _createConfigurationFromBox(
    RemoteStorageConfigurationBox src,
  ) {
    switch (src.type) {
      case RemoteConfigurationTypeData.git:
        final value = src.value;
        if (value is Map<String, dynamic>) {
          final config = GitConfigurationData.fromJson(value);
          return RemoteConfiguration.git(
            token: config.token,
            repo: config.repo,
            owner: config.owner,
            branch: config.branch,
            fileName: config.fileName,
          );
        } else {
          return null;
        }
      case RemoteConfigurationTypeData.googleDrive:
        final value = src.value;
        if (value is Map<String, dynamic>) {
          final config = GoogleDriveConfigurationData.fromJson(value);
          return RemoteConfiguration.google(fileName: config.fileName);
        } else {
          return null;
        }
      case RemoteConfigurationTypeData.unknown:
        return null;
    }
  }
}
