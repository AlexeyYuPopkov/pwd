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
        cacheFileName,
        cacheTmpFileName,
      ];

  @override
  String get cacheFileName => 'google_drive_cache';

  @override
  String get cacheTmpFileName => 'google_drive_cache_tmp';
}
