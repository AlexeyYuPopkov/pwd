import 'package:flutter_test/flutter_test.dart';

import 'pin_screen_finders.dart';

final class PinScreenRobot {
  PinScreenRobot(this.tester);
  final WidgetTester tester;

  late final _finders = PinScreenFinders();

  Future<void> checkInitialState() async {
    await tester.pumpAndSettle();

    await Future.wait([
      tester.ensureVisible(_finders.pinField),
      tester.ensureVisible(_finders.nextButton),
    ]);

    expect(_finders.pinField, findsOneWidget);
    expect(_finders.nextButton, findsOneWidget);
  }

  Future<void> fillFormAndLogin() async {
    await tester.pumpAndSettle();

    await tester.tap(_finders.pinField);
    await tester.pumpAndSettle();
    await tester.enterText(_finders.pinField, '3333');

    await tester.tap(_finders.nextButton);

    await tester.pumpAndSettle();
  }
}
