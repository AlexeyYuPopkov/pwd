import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'google_drive_configuration_screen_finders.dart';
import 'google_drive_test_data.dart';

final class GoogleDriveConfigurationScreenRobot {
  GoogleDriveConfigurationScreenRobot(this.tester);
  final WidgetTester tester;

  late final _finders = GoogleDriveConfigurationScreenFinders();

  Future<void> checkInitialState() async {
    await Future.wait([
      tester.ensureVisible(_finders.filenameTextField),
      tester.ensureVisible(_finders.saveButton),
    ]);

    expect(_finders.filenameTextField, findsOneWidget);
    expect(_finders.saveButton, findsOneWidget);

    expect(
      tester.widget<OutlinedButton>(_finders.saveButton).enabled,
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
    await tester.tap(_finders.saveButton);
  }
}
