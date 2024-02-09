import 'dart:typed_data';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/notes/domain/model/google_drive_file.dart';

abstract interface class GoogleRepository {
  Future<GoogleDriveFile?> getFile({required GoogleDriveConfiguration target});
  Future<Stream<List<int>>?> downloadFile(GoogleDriveFile file);

  Future<GoogleDriveFile> updateRemote(
    Uint8List data, {
    required GoogleDriveConfiguration target,
  });

  Future<void> logout();
}
