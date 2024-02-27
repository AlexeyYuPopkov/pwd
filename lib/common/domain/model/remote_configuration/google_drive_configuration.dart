part of 'remote_configuration.dart';

final class GoogleDriveConfiguration extends RemoteConfiguration {
  @override
  final type = ConfigurationType.googleDrive;

  final String fileName;

  const GoogleDriveConfiguration({
    required this.fileName,
  });

  @override
  List<Object?> get props => [
        fileName,
        localCacheFileName,
        localCacheTmpFileName,
      ];

  @override
  String get localCacheFileName => 'google_drive_cache';

  @override
  String get localCacheTmpFileName => 'google_drive_cache_tmp';
}
