import 'package:pwd/notes/domain/sync_requests_parameters/get_db_response.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';

abstract class RemoteDataStorageRepository {
  Future<PutDbResponse> putDb({required PutDbRequest request});

  Future<GetDbResponse> getDb();
}
