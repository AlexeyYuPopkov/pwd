part of 'remote_configuration.dart';

final class GoogleDriveConfiguration extends RemoteConfiguration {
  String get folderName => 'KeyMemo';

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
