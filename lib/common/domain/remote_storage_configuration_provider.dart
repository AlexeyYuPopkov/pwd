import 'package:pwd/common/domain/model/remote_storage_configuration.dart';

abstract class RemoteStorageConfigurationProvider {
  RemoteStorageConfigurations get currentConfiguration;
  Stream<RemoteStorageConfigurations> get configuration;

  Future<void> setConfiguration(RemoteStorageConfigurations configuration);
  Future<void> dropConfiguration();
}
