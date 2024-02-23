import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/settings/presentation/configuration_screen/google_drive_configuration_screen/google_drive_configuration_screen_test_helper.dart';

final class GoogleDriveConfigurationScreenFinders {
  final filenameTextField = find.byKey(
    const Key(GoogleDriveConfigurationScreenTestHelper.filenameTextFieldKey),
  );

  final saveButton = find.byKey(
    const Key(GoogleDriveConfigurationScreenTestHelper.saveButton),
  );
}
