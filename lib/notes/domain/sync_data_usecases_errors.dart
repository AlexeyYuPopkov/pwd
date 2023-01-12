import 'package:pwd/common/domain/errors/app_error.dart';

class SyncDataError extends AppError {
  SyncDataError({required super.parentError}) : super(message: '');
}
