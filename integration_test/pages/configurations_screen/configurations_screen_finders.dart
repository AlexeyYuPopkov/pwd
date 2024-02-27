import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/settings/presentation/configuration_screen/configurations_screen_test_helper.dart';

final class ConfigurationsScreenFinders {
  final nextButton = find.byKey(
    const Key(ConfigurationsScreenTestHelper.nextButtonKey),
  );

  Finder getSwitchFor(ConfigurationType type) => find.byKey(
        Key(
          ConfigurationsScreenTestHelper.getSwitchKeyFor(type),
        ),
      );

  late final gitSwitch = getSwitchFor(ConfigurationType.git);
  late final googleDriveSwitch = getSwitchFor(ConfigurationType.googleDrive);
}
