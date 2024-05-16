import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

import '../../../test/settings/presentation/configurations_screen/configurations_screen_finders.dart';

final class ConfigurationsScreenRobot {
  ConfigurationsScreenRobot(this.tester);
  final WidgetTester tester;

  late final _finders = ConfigurationsScreenFinders();

  Future<void> checkNoDataPlaceholderState() async {
    await tester.pumpAndSettle();

    await Future.wait([
      tester.ensureVisible(_finders.noDataPlaceholder),
      tester.ensureVisible(_finders.noDataPlaceholderButton),
      tester.ensureVisible(_finders.addNoteConfigurationButton),
    ]);

    expect(
      tester.widget<OutlinedButton>(_finders.noDataPlaceholderButton).enabled,
      true,
      reason: 'ConfigurationsScreen, No data placeholder button - disabled',
    );
  }

  Future<void> gotoNewGoogleDriveConfiguration() async {
    await tester.tap(_finders.noDataPlaceholderButton);
    await tester.pumpAndSettle();

    expect(_finders.googleActionSheetFinder, findsOneWidget);
    expect(_finders.gitActionSheetFinder, findsOneWidget);
    expect(_finders.cancelActionSheetFinder, findsOneWidget);

    await tester.tap(_finders.googleActionSheetFinder);
    await tester.pumpAndSettle();
  }

  Future<void> gotoNewGitConfiguration() async {
    await tester.tap(_finders.noDataPlaceholderButton);
    await tester.pumpAndSettle();

    expect(_finders.googleActionSheetFinder, findsOneWidget);
    expect(_finders.gitActionSheetFinder, findsOneWidget);
    expect(_finders.cancelActionSheetFinder, findsOneWidget);

    await tester.tap(_finders.gitActionSheetFinder);
    await tester.pumpAndSettle();
  }

  Future<void> gotoGoogleDriveConfiguration() async {
    await tester.pumpAndSettle();

    expect(
      _finders.getItemFor(ConfigurationType.googleDrive),
      findsOneWidget,
    );

    await tester.tap(_finders.getItemFor(ConfigurationType.googleDrive));
    await tester.pumpAndSettle();
  }

  Future<void> gotoGitConfiguration() async {
    await tester.pumpAndSettle();

    expect(
      _finders.getItemFor(ConfigurationType.git),
      findsOneWidget,
    );

    await tester.tap(_finders.getItemFor(ConfigurationType.git));
    await tester.pumpAndSettle();
  }
}
