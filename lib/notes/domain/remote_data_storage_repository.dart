import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/get_db_response.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';

abstract class RemoteDataStorageRepository {
  Future<PutDbResponse> putDb({
    required PutDbRequest request,
    required GitConfiguration configuration,
  });

  // Future<PutDbResponse> putRealmDb({
  //   required PutDbRequest request,
  //   required GitConfiguration configuration,
  // });

  Future<GetDbResponse> getDb({
    required GitConfiguration configuration,
  });
}
