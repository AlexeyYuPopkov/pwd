import 'remote_file.dart';

final class GoogleDriveFile implements RemoteFile {
  final String id;
  @override
  final String checksum;
  final String name;

  const GoogleDriveFile({
    required this.id,
    required this.checksum,
    required this.name,
  });
}
