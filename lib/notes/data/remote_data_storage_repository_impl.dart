import 'package:pwd/common/data_tools/mapper.dart';
import 'package:pwd/common/domain/errors/network_error_mapper.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/notes/data/sync_data_service/git_service_api.dart';
import 'package:pwd/notes/data/sync_models/put_db_request_data.dart';
import 'package:pwd/notes/domain/remote_data_storage_repository.dart';
import 'package:pwd/notes/domain/database_path_provider.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/get_db_response.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';

class RemoteDataStorageRepositoryImpl implements RemoteDataStorageRepository {
  static const _token = 'Bearer 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';

  final RemoteStorageConfiguration remoteStorageConfiguration;
  final GitServiceApi service;
  final DatabasePathProvider databasePathProvider;

  final Mapper<PutDbRequestData, PutDbRequest> putDbRequestMapper;

  final NetworkErrorMapper errorMapper;

  RemoteDataStorageRepositoryImpl({
    required this.remoteStorageConfiguration,
    required this.service,
    required this.databasePathProvider,
    required this.errorMapper,
    required this.putDbRequestMapper,
  });

  @override
  Future<PutDbResponse> putDb({required PutDbRequest request}) async {
    PutDbRequest adjustedWithBranch(PutDbRequest request) {
      final branch = remoteStorageConfiguration.branch;
      if (branch != null && branch.isNotEmpty) {
        return request.copyWithBranch(branch: branch);
      }

      return request;
    }

    return service
        .putDb(
          owner: remoteStorageConfiguration.owner,
          repo: remoteStorageConfiguration.repo,
          filename: _fileNameWithExtension(remoteStorageConfiguration.fileName),
          body: putDbRequestMapper.toData(adjustedWithBranch(request)),
          token: _token,
        )
        .catchError(
          (e) => throw errorMapper(e),
        );
  }

  @override
  Future<GetDbResponse> getDb() => service.getDb(
        token: _token,
        owner: remoteStorageConfiguration.owner,
        repo: remoteStorageConfiguration.repo,
        filename: _fileNameWithExtension(remoteStorageConfiguration.fileName),
        branch: remoteStorageConfiguration.branch,
      );

  String _fileNameWithExtension(String str) {
    return '$str.json';
  }
}
