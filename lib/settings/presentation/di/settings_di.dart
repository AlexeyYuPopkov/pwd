import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/settings/domain/drop_remote_Storage_Configuration_usecase.dart';

final class SettingsDi extends DiModule {
  @override
  void bind(DiStorage di) {
    di.bind<DropRemoteStorageConfigurationUsecase>(
      module: this,
      () => DropRemoteStorageConfigurationUsecase(
        remoteStorageConfigurationProvider: di.resolve(),
        notesRepository: di.resolve(),
        pinUsecase: di.resolve(),
        shouldCreateRemoteStorageFileUsecase: di.resolve(),
        localRepository: di.resolve(),
      ),
    );
  }
}
