import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

final class GoogleDriveTestData {
  static GoogleDriveConfiguration createTestConfiguration() =>
      const GoogleDriveConfiguration(
        fileName: 'test_notes',
      );
}

// abstract interface class GoogleRepository {
//   Future<GoogleDriveFile?> getFile({required GoogleDriveConfiguration target});
//   Future<Stream<List<int>>?> downloadFile(GoogleDriveFile file);

//   Future<GoogleDriveFile> updateRemote(
//     Uint8List data, {
//     required GoogleDriveConfiguration target,
//   });

//   Future<void> logout();
// }
