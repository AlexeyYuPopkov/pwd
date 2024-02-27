import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/base_pin.dart';

import 'local_storage_target.dart';

part 'google_drive_configuration.dart';
part 'git_configuration.dart';

enum ConfigurationType {
  git,
  googleDrive,
}

sealed class RemoteConfiguration extends Equatable {
  const RemoteConfiguration();

  const factory RemoteConfiguration.git({
    required String token,
    required String repo,
    required String owner,
    required String? branch,
    required String fileName,
  }) = GitConfiguration;

  const factory RemoteConfiguration.google({
    required String fileName,
  }) = GoogleDriveConfiguration;

  ConfigurationType get type;

  String get localCacheFileName;
  String get localCacheTmpFileName;
}

extension GetLocalStorageTarget on RemoteConfiguration {
  LocalStorageTarget getTarget({required Pin pin}) {
    return LocalStorageTarget(
      key: pin.pinSha512,
      cacheFileName: localCacheFileName,
      cacheTmpFileName: localCacheTmpFileName,
    );
  }
}
