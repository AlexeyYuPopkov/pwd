import 'package:di_storage/di_storage.dart';
import 'package:pwd/settings/domain/save_configurations_usecase.dart';

final class SettingsDi extends DiScope {
  @override
  void bind(DiStorage di) {
    di.bind<SaveConfigurationsUsecase>(
      module: this,
      () => SaveConfigurationsUsecase(
        remoteStorageConfigurationProvider: di.resolve(),
        pinUsecase: di.resolve(),
        localRepository: di.resolve(),
        googleRepository: di.resolve(),
        checksumChecker: di.resolve(),
      ),
    );
  }
}
