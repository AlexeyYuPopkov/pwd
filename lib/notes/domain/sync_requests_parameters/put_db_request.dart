import 'package:equatable/equatable.dart';

class PutDbRequest extends Equatable {
  final String message;
  final String content;
  final String? sha;
  final Committer committer;
  final String? branch;

  const PutDbRequest({
    required this.message,
    required this.content,
    required this.sha,
    required this.committer,
    required this.branch,
  });

  PutDbRequest copyWithBranch({
    String? branch,
  }) {
    return PutDbRequest(
      message: message,
      content: content,
      sha: sha,
      committer: committer,
      branch: branch ?? this.branch,
    );
  }

  @override
  List<Object?> get props => [
        message,
        content,
        sha,
        committer,
        branch,
      ];
}

class Committer {
  final String name;
  final String email;

  const Committer({
    required this.name,
    required this.email,
  });
}
