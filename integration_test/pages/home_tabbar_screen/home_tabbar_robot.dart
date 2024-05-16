import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../configuration_undefined_screen/configuration_undefined_screen_robot.dart';
import 'home_tabbar_finders.dart';

final class HomeTabbarRobot {
  HomeTabbarRobot(this.tester);
  final WidgetTester tester;

  late final _finders = HomeTabbarFinders();

  late final configurationUndefinedScreenRobot =
      ConfigurationUndefinedScreenRobot(tester);

  Future<void> checkInitialState() async {
    await tester.pumpAndSettle(Durations.extralong4);

    await Future.wait([
      tester.ensureVisible(_finders.configurationUndefinedItemIcon),
      tester.ensureVisible(_finders.settingsItemIcon),
    ]);

    await configurationUndefinedScreenRobot.checkInitialState();

    expect(_finders.configurationUndefinedItemIcon, findsOneWidget);
    expect(_finders.settingsItemIcon, findsOneWidget);
  }

  Future<void> checkGitEnabledState() async {
    await tester.pumpAndSettle();

    await Future.wait([
      tester.ensureVisible(_finders.gitItemIcon),
      tester.ensureVisible(_finders.settingsItemIcon),
    ]);

    expect(_finders.gitItemIcon, findsOneWidget);
    expect(_finders.settingsItemIcon, findsOneWidget);
  }

  Future<void> checkGoogleDriveEnabledState() async {
    await tester.pumpAndSettle();

    await Future.wait([
      tester.ensureVisible(_finders.googleDriveItemIcon),
      tester.ensureVisible(_finders.settingsItemIcon),
    ]);

    expect(_finders.googleDriveItemIcon, findsOneWidget);
    expect(_finders.settingsItemIcon, findsOneWidget);
  }

  Future<void> tapSettings() async {
    await tester.pumpAndSettle();
    await tester.tap(_finders.settingsItemIcon);
    await tester.pumpAndSettle();
  }
}
