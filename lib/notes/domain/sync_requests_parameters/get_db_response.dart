import 'package:pwd/notes/domain/model/remote_file.dart';

class GetDbResponse implements RemoteFile {
  final String sha;
  final String content;
  final String downloadUrl;

  const GetDbResponse({
    required this.sha,
    required this.content,
    required this.downloadUrl,
  });

  @override
  String get checksum => sha;
}
