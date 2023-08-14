import 'package:pwd/common/domain/model/remote_storage_configuration.dart';

abstract class RemoteStorageConfigurationProvider {
  Future<RemoteStorageConfiguration> get configuration;
  Future<void> setConfiguration(RemoteStorageConfiguration configuration);
  Future<void> dropConfiguration();
}
