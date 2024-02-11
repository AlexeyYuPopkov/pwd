import 'package:pwd/common/domain/errors/app_error.dart';

sealed class SyncDataError extends AppError {
  const SyncDataError({required super.parentError}) : super(message: '');

  const factory SyncDataError.unknown({
    required Object? parentError,
  }) = UnknownSyncDataError;
  const factory SyncDataError.fileNotFound({
    required Object? parentError,
  }) = FileNotFound;

  const factory SyncDataError.shouldCreateFile({
    required Object? parentError,
  }) = ShouldCreateFileError;
}

final class UnknownSyncDataError extends SyncDataError {
  const UnknownSyncDataError({required super.parentError});
}

final class FileNotFound extends SyncDataError {
  const FileNotFound({required super.parentError});
}

final class ShouldCreateFileError extends SyncDataError {
  const ShouldCreateFileError({required super.parentError});
}
