import 'package:di_storage/di_storage.dart';
import 'package:pwd/notes/data/datasource/checksum_checker_impl.dart';
import 'package:pwd/notes/data/datasource/deleted_items_provider_impl.dart';
import 'package:pwd/notes/data/datasource/realm_datasource_impl.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/deleted_items_provider.dart';
import 'package:pwd/notes/domain/google_repository.dart';

import 'package:pwd/notes/data/datasource/google_repository_impl.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_google_drive_item_usecase.dart';
import 'package:pwd/notes/domain/usecases/google_drive_notes_provider_usecase.dart';

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

    _bindUsecases(di);
  }

  void _bindUsecases(DiStorage di) async {
    di.bind<ChecksumChecker>(
      module: this,
      () => const ChecksumCheckerImpl(),
    );

    di.bind<DeletedItemsProvider>(
      module: this,
      () => const DeletedItemsProviderImpl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<GoogleDriveNotesProviderUsecase>(
      module: this,
      () => GoogleDriveNotesProviderUsecase(
        repository: di.resolve(),
        pinUsecase: di.resolve(),
        checksumChecker: di.resolve(),
        deletedItemsProvider: di.resolve(),
      ),
      lifeTime: const LifeTime.single(),
    );

    di.bind<SyncGoogleDriveItemUsecase>(
      module: this,
      () => SyncGoogleDriveItemUsecase(
        googleRepository: di.resolve(),
        realmRepository: di.resolve(),
        pinUsecase: di.resolve(),
        checksumChecker: di.resolve(),
        deletedItemsProvider: di.resolve(),
      ),
    );
  }
}
