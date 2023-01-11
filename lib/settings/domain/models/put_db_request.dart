class PutDbRequest {
  final String message;
  final String content;
  final Committer committer;

  const PutDbRequest({
    required this.message,
    required this.content,
    required this.committer,
  });
}

class Committer {
  final String name;
  final String email;

  const Committer({
    required this.name,
    required this.email,
  });
}
