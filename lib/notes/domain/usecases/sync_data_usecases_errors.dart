import 'package:pwd/common/domain/errors/app_error.dart';

sealed class SyncDataError extends AppError {
  const SyncDataError({required super.parentError}) : super(message: '');

  const factory SyncDataError.unknown({
    required Object? parentError,
  }) = UnknownSyncDataError;
}

final class UnknownSyncDataError extends SyncDataError {
  const UnknownSyncDataError({required super.parentError});
}
