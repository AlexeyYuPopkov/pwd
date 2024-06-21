import 'dart:core';
import 'dart:typed_data';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;

import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/data/datasource/google_repository_impl/google_repository_impl_part.dart';
import 'package:pwd/notes/data/mappers/google_file_mapper.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/model/google_error.dart';
import 'package:pwd/notes/domain/model/google_drive_file.dart';

final class GoogleRepositoryImpl
    with GoogleApiFolderHelper
    implements GoogleRepository {
  static const _scopes = [
    'email',
    'https://www.googleapis.com/auth/drive.file',
  ];

  final googleSignIn = GoogleSignIn(scopes: _scopes);

  @override
  Future<GoogleDriveFile?> getFile({
    required GoogleDriveConfiguration target,
  }) async {
    final api = await _getDriveApi();
    return getFileInFolder(api: api, target: target).then(
      (e) {
        final file = e.file;
        return file == null ? null : GoogleFileMapper.toDomain(file);
      },
    );
  }

  @override
  Future<GoogleDriveFile> updateRemote(
    Uint8List data, {
    required GoogleDriveConfiguration configuration,
  }) async {
    final api = await _getDriveApi();

    final file = await updateOrCreateFileInFolder(
      api: api,
      target: configuration,
      data: data,
    );

    final result = GoogleFileMapper.toDomain(file);
    if (result == null) {
      throw const GoogleError.canNotCreateFile();
    } else {
      return result;
    }
  }

  @override
  Future<Stream<List<int>>?> downloadFile(GoogleDriveFile file) async {
    final api = await _getDriveApi();

    return downloadFileWithId(api: api, fileId: file.id);
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

    final headers = await user.authHeaders;

    if (headers.isEmpty) {
      throw const GoogleError.canNotAuthorize();
    }

    final client = http.Client();

    final authClient = _AuthClient(client, headers);
    return drive.DriveApi(authClient);
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
