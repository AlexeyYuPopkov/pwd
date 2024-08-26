import 'package:pwd/common/domain/errors/app_error.dart';

sealed class DbError extends AppError {
  const DbError({
    super.reason,
    AppError? super.parentError,
  }) : super(message: '');

  const factory DbError.notFound() = DbNotFoundError;
}

final class DbNotFoundError extends DbError {
  const DbNotFoundError();
}
