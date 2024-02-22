import 'package:pwd/common/domain/model/remote_storage_configuration.dart';

abstract class RemoteStorageConfigurationProvider {
  RemoteStorageConfigurations get currentConfiguration;

  Future<void> setConfigurations(RemoteStorageConfigurations configurations);
  Future<void> dropConfiguration();
}
