import 'package:di_storage/di_storage.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';
import 'package:pwd/common/domain/model/app_configuration.dart';

final class AppConfigurationProviderTool {
  static void bindAppConfigurationProvider() {
    DiStorage.shared.bind<AppConfigurationProvider>(
      module: null,
      () => CustomMockAppConfigurationProvider(),
      lifeTime: const LifeTime.single(),
    );
  }
}

class CustomMockAppConfigurationProvider extends AppConfigurationProvider {
  @override
  AppConfiguration get currentConfiguration => const AppConfiguration(
        proxyData: null,
        showRawErrors: false,
      );

  @override
  Future<void> dropEnvironment() => throw UnimplementedError();

  @override
  Future<AppConfiguration> getAppConfiguration() => throw UnimplementedError();

  @override
  Future<void> setEnvironment(AppConfiguration enviroment) =>
      throw UnimplementedError();
}
