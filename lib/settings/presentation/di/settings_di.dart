import 'package:di_storage/di_storage.dart';
import 'package:pwd/settings/domain/add_configurations_usecase.dart';
import 'package:pwd/settings/domain/remove_configurations_usecase.dart';

final class SettingsDi extends DiScope {
  @override
  void bind(DiStorage di) {
    di.bind<AddConfigurationsUsecase>(
      module: this,
      () => AddConfigurationsUsecase(
        remoteStorageConfigurationProvider: di.resolve(),
        pinUsecase: di.resolve(),
      ),
    );

    di.bind<RemoveConfigurationsUsecase>(
      module: this,
      () => RemoveConfigurationsUsecase(
        remoteStorageConfigurationProvider: di.resolve(),
        pinUsecase: di.resolve(),
        localRepository: di.resolve(),
        googleRepository: di.resolve(),
        checksumChecker: di.resolve(),
      ),
    );
  }
}
