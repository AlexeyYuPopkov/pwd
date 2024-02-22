import 'package:flutter_test/flutter_test.dart';

import 'settings_screen_finders.dart';

final class SettingsRobot {
  SettingsRobot(this.tester);
  final WidgetTester tester;

  late final _finders = SettingsScreenFinders();

  Future<void> checkInitialState() async {
    await tester.pumpAndSettle();

    await Future.wait([
      tester.ensureVisible(_finders.remoteConfigurationItem),
      tester.ensureVisible(_finders.developerSettingsItem),
      tester.ensureVisible(_finders.logoutItem),
    ]);

    expect(_finders.remoteConfigurationItem, findsOneWidget);
    expect(_finders.developerSettingsItem, findsOneWidget);
    expect(_finders.logoutItem, findsOneWidget);
  }

  Future<void> tapRemoteConfiguration() async {
    await tester.pumpAndSettle();
    await tester.tap(_finders.remoteConfigurationItem);
  }
}
