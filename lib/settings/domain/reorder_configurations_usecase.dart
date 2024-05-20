import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/tools/list_helper.dart';

final class ReorderConfigurationsUsecase with ListHelper {
  final RemoteConfigurationProvider _remoteStorageConfigurationProvider;

  ReorderConfigurationsUsecase({
    required RemoteConfigurationProvider remoteStorageConfigurationProvider,
  }) : _remoteStorageConfigurationProvider = remoteStorageConfigurationProvider;

  Future<void> execute({required int oldIndex, required int newIndex}) async {
    final items = _remoteStorageConfigurationProvider.currentConfiguration;

    final result = moveItem(
      src: items.configurations,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );

    await _remoteStorageConfigurationProvider.setConfigurations(
      RemoteConfigurations.createOrThrow(configurations: result),
    );
  }
}
