import 'package:pwd/common/presentation/di/network_di.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/data/local_repository_impl.dart';
import 'package:pwd/notes/data/remote_data_storage_repository_impl.dart';
import 'package:pwd/notes/data/sync_data_mappers/put_db_request_mapper.dart';
import 'package:pwd/notes/data/sync_data_service/git_service_api.dart';
import 'package:pwd/notes/domain/local_repository.dart';
import 'package:pwd/notes/domain/remote_data_storage_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_notes_variant_usecase.dart';

class SyncDi extends DiModule {
  @override
  void bind(DiStorage di) async {
    di.bind<RemoteDataStorageRepository>(
      module: this,
      () => RemoteDataStorageRepositoryImpl(
        service: GitServiceApi(
          di.resolve<UnAuthDio>(),
        ),
        putDbRequestMapper: PutDbRequestMapper(),
        errorMapper: di.resolve(),
      ),
    );

    di.bind<SyncDataUsecase>(
      module: this,
      () => SyncDataUsecase(
        remoteStorageConfigurationProvider: di.resolve(),
        remoteStorageRepository: di.resolve(),
        notesRepository: di.resolve(),
        notesProvider: di.resolve(),
      ),
    );

    _bindVariant(di);
  }
}

extension _Variant on SyncDi {
  void _bindVariant(DiStorage di) async {
    di.bind<LocalRepository>(
      module: this,
      () => LocalRepositoryImpl(),
    );

    di.bind<SyncNotesVariantUsecase>(
      module: this,
      () => SyncNotesVariantUsecase(
        repository: di.resolve(),
      ),
    );
  }
}
