import 'package:di_storage/di_storage.dart';
import 'package:pwd/notes/data/datasource/checksum_checker_impl.dart';
import 'package:pwd/notes/data/datasource/realm_datasource_impl.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/google_repository.dart';

import 'package:pwd/notes/data/datasource/google_repository_impl.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/delete_note_usecase.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_google_drive_item_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase_locator.dart';

final class GoogleAndRealmDi extends DiScope {
  @override
  void bind(DiStorage di) {
    di.bind<RealmLocalRepository>(
      module: this,
      () => RealmDatasourceImpl(),
    );

    di.bind<GoogleRepository>(
      module: this,
      () => GoogleRepositoryImpl(),
      // lifeTime: const LifeTime.single(),
    );

    bindUsecases(di);
  }

  void bindUsecases(DiStorage di) async {
    di.bind<ChecksumChecker>(
      module: this,
      () => const ChecksumCheckerImpl(),
    );

    di.bind<SyncGoogleDriveItemUsecase>(
      module: this,
      () => SyncGoogleDriveItemUsecase(
        remoteRepository: di.resolve(),
        realmRepository: di.resolve(),
        pinUsecase: di.resolve(),
        checksumChecker: di.resolve(),
      ),
    );

    di.bind<SyncUsecase>(
      module: this,
      () => SyncUsecaseLocator(),
    );

    di.bind<DeleteNoteUsecase>(
      module: this,
      () => DeleteNoteUsecase(
        pinUsecase: di.resolve(),
        localRepository: di.resolve(),
        syncUsecase: di.resolve(),
        checksumChecker: di.resolve(),
      ),
    );

    di.bind<NotesProviderUsecase>(
      module: this,
      () => NotesProviderUsecase(
        repository: di.resolve(),
        pinUsecase: di.resolve(),
        checksumChecker: di.resolve(),
      ),
      lifeTime: const LifeTime.single(),
    );
  }
}
