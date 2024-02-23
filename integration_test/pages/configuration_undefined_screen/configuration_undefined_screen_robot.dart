import 'package:flutter_test/flutter_test.dart';

import 'configuration_undefined_screen_finders.dart';

final class ConfigurationUndefinedScreenRobot {
  ConfigurationUndefinedScreenRobot(this.tester);
  final WidgetTester tester;

  late final _finders = ConfigurationUndefinedScreenFinders();

  Future<void> checkInitialState() async {
    await tester.pumpAndSettle();

    await Future.wait([
      tester.ensureVisible(_finders.label),
      tester.ensureVisible(_finders.button)
    ]);

    expect(_finders.label, findsOneWidget);
    expect(_finders.button, findsOneWidget);
  }

  Future<void> tapButton() async {
    await tester.pumpAndSettle();
    await tester.tap(_finders.button);
    await tester.pumpAndSettle();
  }
}
