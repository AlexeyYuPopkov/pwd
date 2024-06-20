import 'package:pwd/common/domain/errors/app_error.dart';

sealed class GoogleError extends AppError {
  const GoogleError({required super.message, super.parentError});

  const factory GoogleError.cancelled() = GoogleCancelledError;

  const factory GoogleError.canNotAuthorize() = GoogleCanNotAuthorizeError;

  const factory GoogleError.canNotCreateFile() = GoogleCanNotCreateFileError;

  factory GoogleError.canNotFindOrCreateFileInFolder({Object? parentError}) =>
      GoogleCanNotFindOrCreateFileInFolderError(parentError: parentError);

  const factory GoogleError.unspecified({
    String message,
    Object? parentError,
  }) = GoogleUnspecifiedError;
}

final class GoogleCancelledError extends GoogleError {
  const GoogleCancelledError() : super(message: '');
}

final class GoogleCanNotAuthorizeError extends GoogleError {
  const GoogleCanNotAuthorizeError() : super(message: '');
}

final class GoogleCanNotCreateFileError extends GoogleError {
  const GoogleCanNotCreateFileError() : super(message: '');
}

final class GoogleUnspecifiedError extends GoogleError {
  const GoogleUnspecifiedError({super.message = '', super.parentError});
}

final class GoogleCanNotFindOrCreateFileInFolderError extends GoogleError {
  const GoogleCanNotFindOrCreateFileInFolderError({super.parentError})
      : super(message: '');
}
