import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';

abstract class RemoteConfigurationProvider {
  RemoteConfigurations get currentConfiguration;

  Future<void> setConfigurations(RemoteConfigurations configurations);
  // Future<void> dropConfiguration();
}
