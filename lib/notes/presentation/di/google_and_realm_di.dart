import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/data/datasource/realm_datasource_impl.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/local_repository.dart';
import 'package:pwd/notes/domain/usecases/google_repository_impl.dart';
import 'package:pwd/notes/domain/usecases/google_sync_usecase.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase_variant.dart';
import 'package:pwd/notes/domain/usecases/sync_notes_variant_usecase.dart';

final class GoogleAndRealmDi extends DiModule {
  @override
  void bind(DiStorage di) {
    di.bind<LocalRepository>(
      module: this,
      () => RealmDatasourceImpl(),
    );

    di.bind<NotesProviderUsecaseVariant>(
      module: this,
      () => NotesProviderUsecaseVariantImpl(
        repository: di.resolve(),
        pinUsecase: di.resolve(),
      ),
      lifeTime: const LifeTime.single(),
    );

    di.bind<GoogleRepository>(
      module: this,
      () => GoogleRepositoryImpl(),
      lifeTime: const LifeTime.single(),
    );

    _bindUsecases(di);
  }

  void _bindUsecases(DiStorage di) async {
    di.bind<SyncDataVariantUsecase>(
      module: this,
      () => SyncNotesVariantUsecaseImpl(
        repository: di.resolve(),
        pinUsecase: di.resolve(),
        remoteStorageConfigurationProvider: di.resolve(),
        remoteStorageRepository: di.resolve(),
        hashUsecase: di.resolve(),
      ),
    );

    di.bind<GoogleSyncUsecase>(
      module: this,
      () => GoogleSyncUsecase(
        googleSignInUsecase: di.resolve(),
        repository: di.resolve(),
        pinUsecase: di.resolve(),
      ),
    );
  }
}
