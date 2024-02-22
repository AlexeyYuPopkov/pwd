import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/unauth/presentation/pin_page/pin_screen_test_helper.dart';

final class PinScreenFinders {
  final pinField = find.byKey(const Key(PinScreenTestHelper.pinTextField));
  final nextButton = find.byKey(const Key(PinScreenTestHelper.nextButton));
}
