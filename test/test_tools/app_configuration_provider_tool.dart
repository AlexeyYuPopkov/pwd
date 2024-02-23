import 'package:di_storage/di_storage.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';

import '../settings/presentation/configurations_screen_test.dart';

final class AppConfigurationProviderTool {
  static void bindAppConfigurationProvider() {
    DiStorage.shared.bind<AppConfigurationProvider>(
      module: null,
      () => CustomMockAppConfigurationProvider(),
      lifeTime: const LifeTime.single(),
    );
  }
}
