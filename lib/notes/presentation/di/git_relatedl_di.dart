import 'package:di_storage/di_storage.dart';
import 'package:pwd/common/presentation/di/network_di.dart';
import 'package:pwd/notes/data/datasource/remote_data_storage_repository_impl.dart';
import 'package:pwd/notes/data/sync_data_mappers/put_db_request_mapper.dart';
import 'package:pwd/notes/data/sync_data_service/git_service_api.dart';
import 'package:pwd/notes/domain/git_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_git_item_usecase.dart';

final class GitRelatedlDi extends DiScope {
  @override
  void bind(DiStorage di) {
    di.bind<GitRepository>(
      module: this,
      () => RemoteDataStorageRepositoryImpl(
        service: GitServiceApi(
          di.resolve<UnAuthDio>(),
        ),
        putDbRequestMapper: PutDbRequestMapper(),
        errorMapper: di.resolve(),
      ),
    );

    di.bind<SyncGitItemUsecaseShaMap>(
      module: this,
      () => SyncGitItemUsecaseShaMap(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<SyncGitItemUsecase>(
      module: this,
      () => SyncGitItemUsecase(
        remoteRepository: di.resolve(),
        realmRepository: di.resolve(),
        pinUsecase: di.resolve(),
        checksumChecker: di.resolve(),
        deletedItemsProvider: di.resolve(),
        syncGitItemUsecaseShaMap: di.resolve(),
        getFileServiceApi: di.resolve(),
      ),
    );
  }
}
