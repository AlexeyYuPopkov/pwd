class AppError {
  final String message;
  final Object? parentError;

  const AppError({
    required this.message,
    this.parentError,
  });

  @override
  String toString() {
    return [
      '$runtimeType:',
      if (message.isNotEmpty) message,
      if (parentError != null) parentError.toString(),
    ].join('\n');
  }
}
