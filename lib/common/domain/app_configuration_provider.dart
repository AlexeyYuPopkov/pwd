import 'package:pwd/common/domain/model/app_configuration.dart';

abstract class AppConfigurationProvider {
  AppConfiguration get currentConfiguration;
  Future<AppConfiguration> getAppConfiguration();
  Future<void> setEnvironment(AppConfiguration enviroment);
}
