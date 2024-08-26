/// Path parameters keys
final class PathParameters {
  /// Remote configuration ID
  static const configId = 'id';

  /// Note ID
  static const noteId = 'note_id';

  static String getConfigId({required Map<String, String> pathParameters}) {
    final result = pathParameters[PathParameters.configId];
    assert(result != null && result.isNotEmpty);
    return result ?? '';
  }

  static String getNoteId({required Map<String, String> pathParameters}) {
    final result = pathParameters[PathParameters.noteId];
    assert(result != null && result.isNotEmpty);
    return result ?? '';
  }
}
