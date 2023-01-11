import 'package:pwd/settings/domain/models/put_db_request.dart';

abstract class DataStorageRepository {
  Future<void> putDb({required PutDbRequest request});
}
