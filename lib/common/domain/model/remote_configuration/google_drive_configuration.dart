part of 'remote_configuration.dart';

final class GoogleDriveConfiguration extends RemoteConfiguration {
  @override
  final type = ConfigurationType.googleDrive;

  @override
  final String fileName;

  const GoogleDriveConfiguration({
    required this.fileName,
  });

  @override
  List<Object?> get props => [fileName];
}
