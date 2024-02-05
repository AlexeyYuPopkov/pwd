import 'package:pwd/common/data/model/git_configuration_data.dart';
import 'package:pwd/common/data/model/google_drive_configuration_data.dart';
import 'package:pwd/common/data/model/remote_storage_configurations_data.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';

final class RemoteConfigurationsMapper {
  static RemoteStorageConfigurationsData toData(
    RemoteStorageConfigurations src,
  ) {
    final configurations = src.configurations.map(
      (e) {
        switch (e) {
          case GitConfiguration():
            return _GitConfigurationMapper.toData(e);
          case GoogleDriveConfiguration():
            return _GoogleDriveConfigurationMapper.toData(e);
        }
      },
    );

    return RemoteStorageConfigurationsData(
      git: configurations.whereType<GitConfigurationData>().firstOrNull,
      googleDrive:
          configurations.whereType<GoogleDriveConfigurationData>().firstOrNull,
    );
  }

  static RemoteStorageConfigurations toDomain(
    RemoteStorageConfigurationsData src,
  ) {
    final git = _GitConfigurationMapper.toDomainOrNull(src.git);
    final googleDrive =
        _GoogleDriveConfigurationMapper.toDomainOrNull(src.googleDrive);

    return RemoteStorageConfigurations(
      configurations: [
        if (git != null) git,
        if (googleDrive != null) googleDrive,
      ],
    );
  }
}

// Git configuration mapper
final class _GitConfigurationMapper {
  static GitConfigurationData toData(GitConfiguration src) {
    return GitConfigurationData(
      token: src.token,
      repo: src.repo,
      owner: src.owner,
      branch: src.branch,
      fileName: src.fileName,
    );
  }

  static GitConfiguration toDomain(GitConfigurationData src) {
    return GitConfiguration(
      token: src.token,
      repo: src.repo,
      owner: src.owner,
      branch: src.branch,
      fileName: src.fileName,
    );
  }

  static GitConfiguration? toDomainOrNull(GitConfigurationData? src) =>
      src == null ? null : toDomain(src);
}

// Google drive configuration mapper
final class _GoogleDriveConfigurationMapper {
  static GoogleDriveConfigurationData toData(GoogleDriveConfiguration src) {
    return GoogleDriveConfigurationData(
      filename: src.filename,
    );
  }

  static GoogleDriveConfiguration toDomain(GoogleDriveConfigurationData src) {
    return GoogleDriveConfiguration(
      filename: src.filename,
    );
  }

  static GoogleDriveConfiguration? toDomainOrNull(
          GoogleDriveConfigurationData? src) =>
      src == null ? null : toDomain(src);
}
