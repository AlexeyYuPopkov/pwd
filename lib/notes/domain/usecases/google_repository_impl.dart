import 'dart:core';
import 'dart:typed_data';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:pwd/notes/data/mappers/google_file_mapper.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/model/google_error.dart';
import 'package:pwd/notes/domain/model/google_file.dart';

final class _Consts {
  static const fileName = 'pwd_notes';
  static const fields =
      'nextPageToken, files(id, name, md5Checksum, modifiedTime)';
  static const spaces = 'drive';
  static const scopes = [
    'email',
    'https://www.googleapis.com/auth/drive.file',
  ];
}

final class GoogleRepositoryImpl implements GoogleRepository {
  final googleSignIn = GoogleSignIn(scopes: _Consts.scopes);

  @override
  Future<GoogleFile?> getFile() async {
    final api = await _getDriveApi();

    final first = await api.files
        .list(
      q: 'name = \'$_Consts.fileName\'',
      pageSize: 1,
      pageToken: null,
      spaces: _Consts.spaces,
      $fields: _Consts.fields,
    )
        .then(
      (e) {
        final files = e.files;
        if (files == null || files.isEmpty) {
          return null;
        } else {
          return GoogleFileMapper.toDomain(files[0]);
        }
      },
    );

    return first;
  }

  @override
  Future<GoogleFile> createFileWithData(Uint8List data) async {
    final api = await _getDriveApi();
    final newFile = await api.files.create(
      drive.File(name: _Consts.fileName),
      uploadMedia: drive.Media(
        Stream.value(
          List<int>.from(data),
        ),
        data.length,
      ),
    );

    final result = GoogleFileMapper.toDomain(newFile);
    if (result == null) {
      throw const GoogleError.canNotCreateFile();
    } else {
      return result;
    }

    // return api.files
    //     .update(
    //   newFile,
    //   newFileId,
    //   uploadMedia: drive.Media(
    //     Stream.value(
    //       List<int>.from(data),
    //     ),
    //     data.length,
    //   ),
    //   $fields: _fields,
    // )
    //     .then(
    //   (file) {
    //     final result = RemoteFileMapper.toDomain(file);
    //     if (result == null) {
    //       throw const GoogleError.canNotCreateFile();
    //     } else {
    //       return result;
    //     }
    //   },
    // );
  }

  @override
  Future<Stream<List<int>>?> downloadFile(GoogleFile file) async {
    final fileId = file.id;
    if (fileId.isEmpty) {
      throw const GoogleError.unspecified();
    }

    final api = await _getDriveApi();

    final obj = await api.files.get(
      fileId,
      $fields: _Consts.fields,
      downloadOptions: drive.DownloadOptions.fullMedia,
    );

    if (obj is drive.File) {
      // print(obj.id ?? 'empty');
      return null;
    } else if (obj is drive.Media) {
      // print(obj.contentType);
      return obj.stream;
    } else {
      throw const GoogleError.unspecified();
    }
  }
}

// Private

extension on GoogleRepositoryImpl {
  Future<GoogleSignInAccount> trySignIn() async {
    final account =
        await googleSignIn.signInSilently() ?? await googleSignIn.signIn();

    if (account == null) {
      throw const GoogleError.cancelled();
    }

    return account;
  }

  Future<drive.DriveApi> _getDriveApi() async {
    final user = await trySignIn();

    final client = http.Client();

    final headers = await user.authHeaders;

    if (headers.isEmpty) {
      throw const GoogleError.canNotAuthorize();
    }

    final authClient = _AuthClient(client, headers);
    return drive.DriveApi(authClient);
  }

  // Future<GoogleFile> createFile() async {
  //   final api = await _getDriveApi();
  //   return api.files
  //       .create(drive.File(name: _fileName, spaces: [_spaces]))
  //       .then(
  //     (file) {
  //       final result = GoogleFileMapper.toDomain(file);
  //       if (result == null) {
  //         throw const GoogleError.canNotCreateFile();
  //       } else {
  //         return result;
  //       }
  //     },
  //   );
  // }
}

// AuthClient
final class _AuthClient extends http.BaseClient {
  final http.Client _baseClient;
  final Map<String, String> _headers;

  _AuthClient(this._baseClient, this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _baseClient.send(request);
  }
}
