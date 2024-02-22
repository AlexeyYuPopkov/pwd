import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'configurations_screen_finders.dart';

final class ConfigurationsScreenRobot {
  ConfigurationsScreenRobot(this.tester);
  final WidgetTester tester;

  late final _finders = ConfigurationsScreenFinders();

  Future<void> checkInitialState() async {
    await tester.pumpAndSettle();

    await Future.wait([
      tester.ensureVisible(_finders.gitSwitch),
      tester.ensureVisible(_finders.googleDriveSwitch),
      tester.ensureVisible(_finders.nextButton),
    ]);

    expect(_finders.gitSwitch, findsOneWidget);
    expect(_finders.googleDriveSwitch, findsOneWidget);
    expect(_finders.nextButton, findsOneWidget);

    expect(
      tester.widget<OutlinedButton>(_finders.nextButton).enabled,
      false,
    );
  }

  Future<void> toggleGitConfiguration() async {
    // await tester.pumpAndSettle();
    await tester.ensureVisible(_finders.gitSwitch);
    expect(_finders.gitSwitch, findsOneWidget);
    await tester.tap(_finders.gitSwitch);
    await tester.pumpAndSettle();
  }

  Future<void> saveConfigurations() async {
    await tester.pumpAndSettle();

    expect(
      tester.widget<OutlinedButton>(_finders.nextButton).enabled,
      true,
    );
    await tester.tap(_finders.nextButton);
  }
}
