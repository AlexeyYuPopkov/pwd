import 'package:pwd/common/presentation/di/network_di.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/settings/data/git_data_storage_impl.dart';
import 'package:pwd/settings/data/mappers/put_db_request_mapper.dart';
import 'package:pwd/settings/data/service/git_service_api.dart';
import 'package:pwd/settings/domain/data_storage_repository.dart';
import 'package:pwd/settings/domain/sync_data_usecases.dart';

class SettingsDi extends DiModule {
  @override
  void bind(DiStorage di) {
    di.bind<DataStorageRepository>(
      () => GitDataStorageImpl(
        service: GitServiceApi(
          di.resolve<UnAuthDio>(),
        ),
        databasePathProvider: di.resolve(),
        putDbRequestMapper: PutDbRequestMapper(),
        errorMapper: di.resolve(),
      ),
    );
    
    di.bind<SyncDataUsecases>(
      () => SyncDataUsecases(
        dataStorageRepository: di.resolve(),
        databasePathProvider: di.resolve(),
      ),
    );
  }
}
