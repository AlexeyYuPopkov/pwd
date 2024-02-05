import 'package:pwd/common/presentation/di/network_di.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/data/datasource/database_path_provider_impl.dart';
import 'package:pwd/notes/data/datasource/sql_datasource_impl.dart';
import 'package:pwd/notes/data/mappers/db_note_mapper.dart';
import 'package:pwd/notes/data/remote_data_storage_repository_impl.dart';
import 'package:pwd/notes/data/sync_data_mappers/put_db_request_mapper.dart';
import 'package:pwd/notes/data/sync_data_service/git_service_api.dart';
import 'package:pwd/notes/domain/database_path_provider.dart';
import 'package:pwd/notes/domain/remote_data_storage_repository.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/domain/notes_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecase.dart';

final class GitAndSqlDi extends DiModule {
  @override
  void bind(DiStorage di) {
    di.bind<DatabasePathProvider>(
      module: this,
      () => DatabasePathProviderImpl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<NotesRepository>(
      module: this,
      () => SqlDatasourceImpl(
        databasePathProvider: di.resolve(),
        mapper: DbNoteMapper(),
      ),
      lifeTime: const LifeTime.single(),
    );

    di.bind<NotesProviderUsecase>(
      module: this,
      () => NotesProviderUsecaseImpl(
        repository: di.resolve(),
        hashUsecase: di.resolve(),
        pinRepository: di.resolve(),
      ),
      lifeTime: const LifeTime.single(),
    );

    _bindSync(di);
  }

  void _bindSync(DiStorage di) {
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
      () => SyncDataUsecaseImpl(
        remoteStorageConfigurationProvider: di.resolve(),
        remoteStorageRepository: di.resolve(),
        notesRepository: di.resolve(),
        notesProvider: di.resolve(),
      ),
    );
  }
}

///