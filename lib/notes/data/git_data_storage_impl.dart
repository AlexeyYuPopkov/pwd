import 'package:pwd/common/data_tools/mapper.dart';
import 'package:pwd/common/domain/errors/network_error_mapper.dart';
import 'package:pwd/notes/data/sync_data_service/git_service_api.dart';
import 'package:pwd/notes/data/sync_models/put_db_request_data.dart';
import 'package:pwd/notes/domain/data_storage_repository.dart';
import 'package:pwd/notes/domain/database_path_provider.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/get_db_response.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';

class GitDataStorageImpl implements DataStorageRepository {
  static const _token = 'Bearer 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';

  final GitServiceApi service;
  final DatabasePathProvider databasePathProvider;

  final Mapper<PutDbRequestData, PutDbRequest> putDbRequestMapper;

  final NetworkErrorMapper errorMapper;

  GitDataStorageImpl({
    required this.service,
    required this.databasePathProvider,
    required this.errorMapper,
    required this.putDbRequestMapper,
  });

  @override
  Future<PutDbResponse> putDb({required PutDbRequest request}) async => service
      .putDb(
        body: putDbRequestMapper.toData(request),
        token: _token,
      )
      .catchError(
        (e) => throw errorMapper(e),
      );

  @override
  Future<GetDbResponse> getDb() => service.getDb(
        token: _token,
      );
}
