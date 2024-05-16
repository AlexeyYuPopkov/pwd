import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

import '../../../test/settings/presentation/configurations_screen/configurations_screen_finders.dart';

final class ConfigurationsScreenRobot {
  ConfigurationsScreenRobot();

  final _finders = ConfigurationsScreenFinders();

  Future<void> checkNoDataPlaceholderState(WidgetTester tester) async {
    await tester.pumpAndSettle();

    await tester.ensureVisible(_finders.noDataPlaceholder);
    await tester.ensureVisible(_finders.noDataPlaceholderButton);
    await tester.ensureVisible(_finders.addNoteConfigurationButton);

    expect(
      tester.widget<OutlinedButton>(_finders.noDataPlaceholderButton).enabled,
      true,
      reason: 'ConfigurationsScreen, No data placeholder button - disabled',
    );
  }

  Future<void> gotoNewGoogleDriveConfiguration(WidgetTester tester) async {
    await tester.tap(_finders.noDataPlaceholderButton);
    await tester.pumpAndSettle();

    expect(_finders.googleActionSheetFinder, findsOneWidget);
    expect(_finders.gitActionSheetFinder, findsOneWidget);
    expect(_finders.cancelActionSheetFinder, findsOneWidget);

    await tester.tap(_finders.googleActionSheetFinder);
    await tester.pumpAndSettle();
  }

  Future<void> gotoNewGitConfiguration(WidgetTester tester) async {
    await tester.tap(_finders.noDataPlaceholderButton);
    await tester.pumpAndSettle();

    expect(_finders.googleActionSheetFinder, findsOneWidget);
    expect(_finders.gitActionSheetFinder, findsOneWidget);
    expect(_finders.cancelActionSheetFinder, findsOneWidget);

    await tester.tap(_finders.gitActionSheetFinder);
    await tester.pumpAndSettle();
  }

  Future<void> gotoGoogleDriveConfiguration(WidgetTester tester) async {
    await tester.pumpAndSettle();

    expect(
      _finders.getItemFor(ConfigurationType.googleDrive),
      findsOneWidget,
    );

    await tester.tap(_finders.getItemFor(ConfigurationType.googleDrive));
    await tester.pumpAndSettle();
  }

  Future<void> gotoGitConfiguration(WidgetTester tester) async {
    await tester.pumpAndSettle();

    expect(
      _finders.getItemFor(ConfigurationType.git),
      findsOneWidget,
    );

    await tester.tap(_finders.getItemFor(ConfigurationType.git));
    await tester.pumpAndSettle();
  }
}
