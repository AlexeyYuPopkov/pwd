import 'package:pwd/common/domain/model/app_configuration.dart';

abstract class AppConfigurationProvider {
  Future<AppConfiguration> get appConfiguration;
  Future<void> setEnvironment(AppConfiguration enviroment);
  Future<void> resetEnvironment();
}
