import 'package:pwd/common/domain/model/remote_storage_configuration.dart';

final class ConfigurationsScreenTestHelper {
  static const nextButtonKey = 'ConfigurationsScreenNextButton.TestKey';

  static String getSwitchKeyFor(ConfigurationType type) =>
      'ConfigurationsScreenSwitchKey.${type.toString()}.TestKey';
}
