import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/get_db_response.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';

abstract class RemoteDataStorageRepository {
  Future<PutDbResponse> putDb({
    required PutDbRequest request,
    required RemoteStorageConfiguration configuration,
  });

  Future<GetDbResponse> getDb({
    required RemoteStorageConfiguration configuration,
  });
}
