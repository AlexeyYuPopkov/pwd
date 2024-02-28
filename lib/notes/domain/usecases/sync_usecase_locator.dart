import 'package:di_storage/di_storage.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/usecases/sync_git_item_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_google_drive_item_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

final class SyncUsecaseLocator implements SyncUsecase {
  SyncUsecase getSyncUsecase({required RemoteConfiguration configuration}) {
    switch (configuration) {
      case GoogleDriveConfiguration():
        return DiStorage.shared.resolve<SyncGoogleDriveItemUsecase>();
      case GitConfiguration():
        return DiStorage.shared.resolve<SyncGitItemUsecase>();
    }
  }

  @override
  Future<void> sync({required RemoteConfiguration configuration}) =>
      getSyncUsecase(configuration: configuration)
          .sync(configuration: configuration);

  @override
  Future<void> updateRemote({required RemoteConfiguration configuration}) =>
      getSyncUsecase(configuration: configuration)
          .updateRemote(configuration: configuration);
}
