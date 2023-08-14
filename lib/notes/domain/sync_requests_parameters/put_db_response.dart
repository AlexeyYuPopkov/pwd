class PutDbResponse {
  final PutDbResponseContent content;

  const PutDbResponse({
    required this.content,
  });
}

class PutDbResponseContent {
  final String sha;

  const PutDbResponseContent({
    required this.sha,
  });
}
