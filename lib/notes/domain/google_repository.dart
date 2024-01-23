import 'dart:typed_data';
import 'package:pwd/notes/domain/model/google_file.dart';

abstract interface class GoogleRepository {
  Future<GoogleFile?> getFile();
  Future<Stream<List<int>>?> downloadFile(GoogleFile file);

  Future<GoogleFile> updateRemote(Uint8List data);
}
