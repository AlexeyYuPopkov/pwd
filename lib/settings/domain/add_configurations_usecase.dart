import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';

class AddConfigurationsUsecase {
  final RemoteConfigurationProvider _remoteStorageConfigurationProvider;

  AddConfigurationsUsecase({
    required RemoteConfigurationProvider remoteStorageConfigurationProvider,
    required PinUsecase pinUsecase,
  }) : _remoteStorageConfigurationProvider = remoteStorageConfigurationProvider;

  Future<void> execute(RemoteConfiguration configuration) async {
    final old = _remoteStorageConfigurationProvider.currentConfiguration;

    await _remoteStorageConfigurationProvider.setConfigurations(
      old.addAndCopy(configuration),
    );
  }
}
