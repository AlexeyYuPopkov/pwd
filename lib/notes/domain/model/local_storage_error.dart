// Errors
import 'package:pwd/common/domain/errors/app_error.dart';

sealed class LocalStorageError extends AppError {
  const LocalStorageError({
    super.parentError,
  }) : super(message: '');

  factory LocalStorageError.unknown({Object? parentError}) =>
      UnknownRealmStorageError(parentError: parentError);

  factory LocalStorageError.pinDoesNotMatch({Object? parentError}) =>
      PinDoesNotMatchError(parentError: parentError);
}

final class UnknownRealmStorageError extends LocalStorageError {
  const UnknownRealmStorageError({
    super.parentError,
  });
}

final class PinDoesNotMatchError extends LocalStorageError {
  const PinDoesNotMatchError({
    super.parentError,
  });
}
