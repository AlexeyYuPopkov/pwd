import 'dart:core';
import 'dart:typed_data';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/notes/data/mappers/google_file_mapper.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/model/google_error.dart';
import 'package:pwd/notes/domain/model/google_drive_file.dart';

final class _Consts {
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
  Future<GoogleDriveFile?> getFile({
    required GoogleDriveConfiguration target,
  }) async {
    return _getFile(target: target).then(
      (e) => e == null ? null : GoogleFileMapper.toDomain(e),
    );
  }

  @override
  Future<GoogleDriveFile> updateRemote(
    Uint8List data, {
    required GoogleDriveConfiguration target,
  }) async {
    final api = await _getDriveApi();

    final file = await _getFile(target: target);
    final fileId = file?.id;

    if (file == null || fileId == null || fileId.isEmpty) {
      return createFileWithData(data, target: target);
    }

// https://github.com/google/google-api-objectivec-client/issues/145
    final newFile = await api.files.update(
      drive.File(
        name: target.fileName,
        // parents: file.parents,
        // description: file.description,
      ),
      fileId,
      uploadMedia: drive.Media(
        Stream.value(
          List<int>.from(data),
        ),
        data.length,
      ),
      // uploadOptions:
    );

    final result = GoogleFileMapper.toDomain(newFile);
    if (result == null) {
      throw const GoogleError.canNotCreateFile();
    } else {
      return result;
    }
  }

  @override
  Future<Stream<List<int>>?> downloadFile(GoogleDriveFile file) async {
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

  @override
  Future<void> logout() async {
    await googleSignIn.signOut();
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

  Future<drive.File?> _getFile({
    required GoogleDriveConfiguration target,
  }) async {
    final api = await _getDriveApi();

    final first = await api.files
        .list(
          q: target.fileNameQuery,
          pageSize: 1,
          pageToken: null,
          spaces: _Consts.spaces,
          $fields: _Consts.fields,
        )
        .then(
          (e) => e.files?.firstOrNull,
        );

    return first;
  }

  Future<GoogleDriveFile> createFileWithData(
    Uint8List data, {
    required GoogleDriveConfiguration target,
  }) async {
    final api = await _getDriveApi();
    final newFile = await api.files.create(
      drive.File(name: target.fileName),
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
  }
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

extension on GoogleDriveConfiguration {
  String get fileNameQuery => 'name = \'$fileName\'';
}
