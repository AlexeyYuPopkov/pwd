import 'package:pwd/notes/domain/model/remote_file.dart';

class PutDbResponse implements RemoteFile {
  final PutDbResponseContent content;

  const PutDbResponse({
    required this.content,
  });

  @override
  String get checksum => content.checksum;
}

class PutDbResponseContent implements RemoteFile {
  final String sha;

  const PutDbResponseContent({
    required this.sha,
  });

  @override
  String get checksum => sha;
}
