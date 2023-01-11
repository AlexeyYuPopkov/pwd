import 'package:pwd/common/domain/errors/app_error.dart';

class NetworkError implements AppError {
  @override
  final String message;
  @override
  final Object? parentError;

  final Map<String, dynamic>? details;

  const NetworkError({
    required this.message,
    required this.parentError,
    required this.details,
  });

  const factory NetworkError.unknown({
    required String message,
    required Object? parentError,
    required Map<String, dynamic>? details,
  }) = UnknownNetworkError;

  const factory NetworkError.unauthenticated({
    required String message,
    required Object? parentError,
    required Map<String, dynamic>? details,
  }) = UnknownNetworkError;

  const factory NetworkError.serviceTimeout({
    required String message,
    required Object? parentError,
    required Map<String, dynamic>? details,
  }) = UnknownNetworkError;
}

class UnknownNetworkError extends NetworkError {
  const UnknownNetworkError({
    required super.message,
    required super.parentError,
    required super.details,
  });
}

class UnauthenticatedError extends NetworkError {
  const UnauthenticatedError({
    required super.message,
    required super.parentError,
    required super.details,
  });
}

class ServiceTimeoutError extends NetworkError {
  const ServiceTimeoutError({
    required super.message,
    required super.parentError,
    required super.details,
  });
}
