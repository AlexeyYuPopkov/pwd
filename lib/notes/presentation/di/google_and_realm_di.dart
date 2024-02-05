import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/data/datasource/checksum_checker_impl.dart';
import 'package:pwd/notes/data/datasource/deleted_items_provider_impl.dart';
import 'package:pwd/notes/data/datasource/realm_datasource_impl.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/deleted_items_provider.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/local_repository.dart';
import 'package:pwd/notes/data/datasource/google_repository_impl.dart';
import 'package:pwd/notes/domain/usecases/google_sync_usecase.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase_variant.dart';

final class GoogleAndRealmDi extends DiModule {
  @override
  void bind(DiStorage di) {
    di.bind<LocalRepository>(
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

    di.bind<NotesProviderUsecaseVariant>(
      module: this,
      () => NotesProviderUsecaseVariantImpl(
        repository: di.resolve(),
        pinUsecase: di.resolve(),
        checksumChecker: di.resolve(),
        deletedItemsProvider: di.resolve(),
      ),
      lifeTime: const LifeTime.single(),
    );

    di.bind<GoogleSyncUsecase>(
      module: this,
      () => GoogleSyncUsecase(
        googleRepository: di.resolve(),
        repository: di.resolve(),
        pinUsecase: di.resolve(),
        checksumChecker: di.resolve(),
        deletedItemsProvider: di.resolve(),
      ),
    );
  }
}
