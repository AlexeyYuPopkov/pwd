import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/clocks_widget.dart';
import 'package:pwd/unauth/presentation/pin_page/pin_screen.dart';
import 'package:pwd/unauth/presentation/pin_page/pin_screen_enter_pin_form.dart';
import 'package:pwd/unauth/presentation/pin_page/pin_screen_test_helper.dart';

final class PinScreenFinders {
  final screen = find.byType(PinScreen);
  final clock = find.byType(ClocksWidget);
  final blocConsumer = find.byKey(const Key(PinScreenTestHelper.blocConsumer));
  final form = find.byType(PinScreenEnterPinForm);
  final pinField = find.byKey(const Key(PinScreenTestHelper.pinTextField));
  final pinVisibilityButton =
      find.byKey(const Key(PinScreenTestHelper.pinVisibilityButtonKey));
  final nextButton = find.byKey(const Key(PinScreenTestHelper.nextButton));
}
