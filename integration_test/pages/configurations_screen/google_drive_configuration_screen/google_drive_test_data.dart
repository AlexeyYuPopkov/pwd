import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

final class GoogleDriveTestData {
  static GoogleDriveConfiguration createTestConfiguration() =>
      const GoogleDriveConfiguration(
        fileName: 'test_notes',
      );
}
