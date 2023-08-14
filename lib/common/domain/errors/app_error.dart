class AppError {
  final String message;
  final Object? parentError;

  const AppError({
    required this.message,
    this.parentError,
  });
}
