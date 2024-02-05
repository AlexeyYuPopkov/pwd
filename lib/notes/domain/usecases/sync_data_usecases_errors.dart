import 'package:pwd/common/domain/errors/app_error.dart';

abstract class SyncDataError extends AppError {
  const SyncDataError({required super.parentError}) : super(message: '');

  const factory SyncDataError.unknown({
    required Object? parentError,
  }) = UnknownSyncDataError;
  const factory SyncDataError.destinationNotFound({
    required Object? parentError,
  }) = DestinationNotFound;
}

class UnknownSyncDataError extends SyncDataError {
  const UnknownSyncDataError({required super.parentError});
}

class DestinationNotFound extends SyncDataError {
  const DestinationNotFound({required super.parentError});
}
