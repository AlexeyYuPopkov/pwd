import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/presentation/di/network_di.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/data/remote_data_storage_repository_impl.dart';
import 'package:pwd/notes/data/sync_data_mappers/put_db_request_mapper.dart';
import 'package:pwd/notes/data/sync_data_service/git_service_api.dart';
import 'package:pwd/notes/domain/remote_data_storage_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecase.dart';

class SyncDi extends DiModule {
  @override
  void bind(DiStorage di) async {
    final remoteStorageConfigurationProvider =
        di.resolve<RemoteStorageConfigurationProvider>();
    final remoteStorageConfiguration =
        await remoteStorageConfigurationProvider.configuration;

    di.bind<RemoteDataStorageRepository>(
      module: this,
      () => RemoteDataStorageRepositoryImpl(
        remoteStorageConfiguration: remoteStorageConfiguration,
        service: GitServiceApi(
          di.resolve<UnAuthDio>(),
        ),
        databasePathProvider: di.resolve(),
        putDbRequestMapper: PutDbRequestMapper(),
        errorMapper: di.resolve(),
      ),
    );

    di.bind<SyncDataUsecase>(
      module: this,
      () => SyncDataUsecase(
        dataStorageRepository: di.resolve(),
        notesRepository: di.resolve(),
        notesProvider: di.resolve(),
      ),
    );
  }
}
