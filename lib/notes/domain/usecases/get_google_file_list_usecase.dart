import 'dart:core';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:pwd/common/domain/errors/app_error.dart';

final class GetGoogleFileListUsecase {
  final googleSignIn = GoogleSignIn(
    // clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
    scopes: const [
      'email',
      // 'openid',
      // 'profile',
      'https://www.googleapis.com/auth/drive.file',
    ],
  );

  Future<List<RemoteFile>> execute() async {
    await googleSignIn.signIn();

    final user = googleSignIn.currentUser;
    // onCurrentUserChanged.firstWhere((e) => e != null);

    final client = http.Client();

    final header = await user?.authHeaders;

    if (header != null) {
      final authClient = AuthClient(client, header);
      final api = drive.DriveApi(authClient);

      // api.files.watch(request, 'fileId')

      // api.files.create(request)

      return api.files
          .list(
            q: null,
            pageSize: 100,
            pageToken: null,
            supportsAllDrives: false,
            spaces: 'drive',
            $fields:
                'nextPageToken, files(id, name, md5Checksum, modifiedTime)',
          )
          .then(
            (e) =>
                e.files
                    ?.map(
                      (src) => RemoteFileMapper.toDomain(src),
                    )
                    .whereType<RemoteFile>()
                    .toList() ??
                [],
          );
    } else {
      throw NotAuthorizedError(message: '');
    }
  }
}

final class RemoteFileMapper {
  static RemoteFile? toDomain(File src) {
    final id = src.id;
    final name = src.name;

    final updated = src.modifiedTime;

    final isValid = id != null &&
        id.isNotEmpty &&
        name != null &&
        name.isNotEmpty &&
        updated != null;

    if (isValid) {
      return RemoteFile(
        id: id,
        checksum: src.md5Checksum ?? '',
        name: name,
        updated: updated,
      );
    }

    return null;
  }
}

final class RemoteFile {
  final String id;
  final String checksum;
  final String name;
  final DateTime updated;

  RemoteFile({
    required this.id,
    required this.checksum,
    required this.name,
    required this.updated,
  });
}

final class AuthClient extends http.BaseClient {
  final http.Client _baseClient;
  final Map<String, String> _headers;

  AuthClient(this._baseClient, this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _baseClient.send(request);
  }
}

sealed class GetGoogleFileListUsecaseError extends AppError {
  GetGoogleFileListUsecaseError({required super.message});
}

final class NotAuthorizedError extends AppError {
  NotAuthorizedError({required super.message});
}
