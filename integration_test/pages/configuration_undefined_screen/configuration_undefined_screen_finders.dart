import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/home/presentation/configuration_undefined_screen/configuration_undefined_screen.dart';

final class ConfigurationUndefinedScreenFinders {
  final label = find.byKey(
    const Key(ConfigurationUndefinedScreenTestHelper.label),
  );

  final button = find.byKey(
    const Key(ConfigurationUndefinedScreenTestHelper.button),
  );
}
