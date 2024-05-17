import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import '../configuration_undefined_screen/configuration_undefined_screen_robot.dart';
import 'home_tabbar_finders.dart';

final class HomeTabbarRobot {
  HomeTabbarRobot();

  late final _finders = HomeTabbarFinders();

  late final configurationUndefinedScreenRobot =
      ConfigurationUndefinedScreenRobot();

  Future<void> checkInitialState(WidgetTester tester) async {
    await tester.pumpAndSettle(Durations.extralong4);

    await Future.wait([
      tester.ensureVisible(_finders.configurationUndefinedItemIcon),
      tester.ensureVisible(_finders.settingsItemIcon),
    ]);

    await configurationUndefinedScreenRobot.checkInitialState(tester);

    expect(_finders.configurationUndefinedItemIcon, findsOneWidget);
    expect(_finders.settingsItemIcon, findsOneWidget);
  }

  Future<void> checkGitEnabledState(
    WidgetTester tester, {
    required GitConfiguration config,
  }) async {
    await tester.pumpAndSettle();

    await Future.wait([
      tester.ensureVisible(_finders.notesTabIcon(config)),
      tester.ensureVisible(_finders.settingsItemIcon),
    ]);

    expect(_finders.notesTabIcon(config), findsOneWidget);
    expect(_finders.settingsItemIcon, findsOneWidget);
  }

  Future<void> checkGoogleDriveEnabledState(
    WidgetTester tester, {
    required GoogleDriveConfiguration config,
  }) async {
    await tester.pumpAndSettle();

    await Future.wait([
      tester.ensureVisible(_finders.notesTabIcon(config)),
      tester.ensureVisible(_finders.settingsItemIcon),
    ]);

    expect(_finders.notesTabIcon(config), findsOneWidget);
    expect(_finders.settingsItemIcon, findsOneWidget);
  }

  Future<void> tapSettings(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.tap(_finders.settingsItemIcon);
    await tester.pumpAndSettle();
  }
}
