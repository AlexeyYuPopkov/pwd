import 'package:flutter_test/flutter_test.dart';

import 'pin_screen_finders.dart';

final class PinScreenRobot {
  static const pinStr = '3333';

  PinScreenRobot();

  late final _finders = PinScreenFinders();

  Future<void> checkInitialState(WidgetTester tester) async {
    await tester.pumpAndSettle();

    await Future.wait([
      tester.ensureVisible(_finders.pinField),
      tester.ensureVisible(_finders.nextButton),
    ]);

    expect(_finders.pinField, findsOneWidget);
    expect(_finders.nextButton, findsOneWidget);
  }

  Future<void> fillFormAndLogin(WidgetTester tester) async {
    await tester.pumpAndSettle();

    await tester.tap(_finders.pinField);
    await tester.pumpAndSettle();
    await tester.enterText(_finders.pinField, pinStr);
    await tester.tap(_finders.screen);
    await tester.pumpAndSettle();
    await tester.ensureVisible(_finders.nextButton);
    await tester.tap(_finders.nextButton);

    await tester.pumpAndSettle();
  }
}
