import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/unauth/presentation/configuration_screen/configurations_screen.dart';

final class RemoteConfigRobot {
  const RemoteConfigRobot(this.tester);
  final WidgetTester tester;

  Future<void> configureGit() async {
    await tester.pumpAndSettle();

    final gitSwitchKey = Key(
      'configurations_screen_switch_key_${ConfigurationType.git.toString()}',
    );
    final gitSwitch = find.byKey(gitSwitchKey);

    tester.ensureVisible(gitSwitch);
    expect(gitSwitch, findsOneWidget);

    final googleDriveSwitchKey = Key(
      'configurations_screen_switch_key_${ConfigurationType.googleDrive.toString()}',
    );
    final googleDriveSwitch = find.byKey(googleDriveSwitchKey);

    tester.ensureVisible(googleDriveSwitch);
    expect(googleDriveSwitch, findsOneWidget);

    await tester.tap(gitSwitch);

    await tester.pumpAndSettle();
  }

  Future<void> tapOnNextButtonGit() async {
    await tester.pumpAndSettle();

    final nextButton = find.byKey(
      const Key('configurations_screen_next_button'),
    );

    tester.ensureVisible(nextButton);
    expect(nextButton, findsOneWidget);

    await tester.tap(nextButton);

    await tester.pumpAndSettle();
  }

  Future<void> ensureVisible() async {
    await tester.pumpAndSettle();
    expect(find.byType(ConfigurationsScreen), findsOneWidget);
    await tester.pumpAndSettle();
  }
}
