import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test/settings/presentation/configurations_screen/google_drive_configuration_screen_finders.dart';
import 'google_drive_test_data.dart';

final class GoogleDriveConfigurationScreenRobot {
  GoogleDriveConfigurationScreenRobot(this.tester);
  final WidgetTester tester;

  late final _finders = GoogleDriveConfigurationScreenFinders();

  Future<void> checkInitialState() async {
    await Future.wait([
      tester.ensureVisible(_finders.filenameTextField),
      tester.ensureVisible(_finders.nextButton),
    ]);

    expect(_finders.filenameTextField, findsOneWidget);
    expect(_finders.nextButton, findsOneWidget);

    expect(
      tester.widget<OutlinedButton>(_finders.nextButton).enabled,
      false,
    );
  }

  Future<void> fillForm() async {
    // ?
    // await tester.pumpAndSettle();
    final configuration = GoogleDriveTestData.createTestConfiguration();
    await tester.tap(_finders.filenameTextField);
    await tester.enterText(_finders.filenameTextField, configuration.fileName);
  }

  Future<void> save() async {
    await tester.pumpAndSettle();
    await tester.tap(_finders.nextButton);
    await tester.pumpAndSettle();
  }

  Future<void> deleteConfiguration() async {
    await tester.pumpAndSettle();

    await tester.tap(_finders.nextButton);
    await tester.pumpAndSettle();
    expect(_finders.deleteConfirmationDialog, findsOneWidget);
    expect(_finders.deleteConfirmationDialogOkButton, findsOneWidget);

    await tester.tap(_finders.deleteConfirmationDialogOkButton);

    await tester.pumpAndSettle();
  }
}
