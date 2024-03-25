import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/notes/domain/model/local_storage_error.dart';
import 'package:realm/realm.dart';

final class RealmErrorMapper {
  static AppError toDomain(Object e) {
    if (e is RealmException &&
        e.message.contains('Realm file decryption failed')) {
      return LocalStorageError.pinDoesNotMatch(parentError: e);
    } else {
      return LocalStorageError.unknown(parentError: e);
    }
  }
}
