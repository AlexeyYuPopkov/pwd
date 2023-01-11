import 'package:pwd/settings/domain/models/get_db_response.dart';
import 'package:pwd/settings/domain/models/put_db_request.dart';
import 'package:pwd/settings/domain/models/put_db_response.dart';

abstract class DataStorageRepository {
  Future<PutDbResponse> putDb({required PutDbRequest request});

  Future<GetDbResponse> getDb();
}
