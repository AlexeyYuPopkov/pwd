import 'package:pwd/common/data_tools/mapper.dart';
import 'package:pwd/common/domain/errors/network_error_mapper.dart';
import 'package:pwd/notes/domain/database_path_provider.dart';
import 'package:pwd/settings/data/model/put_db_request_data.dart';
import 'package:pwd/settings/domain/data_storage_repository.dart';
import 'package:pwd/settings/domain/models/put_db_request.dart';

import 'service/git_service_api.dart';

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
  Future<void> putDb({required PutDbRequest request}) async {
    return service
        .putDb(
          body: putDbRequestMapper.toData(request),
          token: _token,
        )
        .then((_) => null)
        .catchError(
          (e) => throw errorMapper(e),
        );
  }
}
