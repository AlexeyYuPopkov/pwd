class AppError {
  final String message;
  final String reason;
  final Object? parentError;

  const AppError({
    required this.message,
    this.reason = '',
    this.parentError,
  });

  @override
  String toString() {
    return [
      '$runtimeType:',
      if (message.isNotEmpty) message,
      if (reason.isNotEmpty) reason,
      if (parentError != null) parentError.toString(),
    ].join('\n');
  }
}
