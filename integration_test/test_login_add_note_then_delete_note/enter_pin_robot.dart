import 'package:flutter/widgets.dart';

import 'package:flutter_test/flutter_test.dart';

class EnterPinRobot {
  const EnterPinRobot(this.tester);
  final WidgetTester tester;

  Future<void> fillEnterPinForm() async {
    await tester.pumpAndSettle();

    final pinField = find.byKey(const Key('test_pin_text_field_key'));

    final onNextButton = find.byKey(
      const Key('test_on_auth_zone_button'),
    );

    await Future.wait([
      tester.ensureVisible(pinField),
      tester.ensureVisible(onNextButton),
    ]);

    expect(pinField, findsOneWidget);
    expect(onNextButton, findsOneWidget);

    await tester.tap(pinField);
    await tester.enterText(pinField, '3333');

    await tester.tap(onNextButton);

    await Future<void>.delayed(const Duration(milliseconds: 500));

    await tester.pumpAndSettle();
  }
}
