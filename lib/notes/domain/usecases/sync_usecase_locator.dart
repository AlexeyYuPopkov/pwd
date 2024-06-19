import 'package:di_storage/di_storage.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/usecases/sync_git_item_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_google_drive_item_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

final class SyncUsecaseLocator implements SyncUsecase {
  @override
  Future<void> execute({
    required RemoteConfiguration configuration,
    required bool force,
  }) =>
      configuration
          .getSyncUsecase()
          .execute(configuration: configuration, force: force);
}

extension on RemoteConfiguration {
  SyncUsecase getSyncUsecase() {
    switch (this) {
      case GoogleDriveConfiguration():
        return DiStorage.shared.resolve<SyncGoogleDriveItemUsecase>();
      case GitConfiguration():
        return DiStorage.shared.resolve<SyncGitItemUsecase>();
    }
  }
}
