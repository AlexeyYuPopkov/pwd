import 'dart:typed_data';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/model/google_error.dart';

final class GetFileInFolderResult {
  final drive.File? file;
  final String folderId;

  GetFileInFolderResult({
    required this.file,
    required this.folderId,
  }) {
    assert(
      folderId.isNotEmpty,
      'GoogleRepositoryImpl: folderId is empty',
    );
  }
}

mixin GoogleApiFolderHelper {
  Future<GetFileInFolderResult> getFileInFolder({
    required drive.DriveApi api,
    required GoogleDriveConfiguration target,
  }) async {
    final folderId = await _findOrCreateFolder(api: api, target: target);

    final result = await _findFileInFolder(
      api: api,
      folderId: folderId,
      target: target,
    );

    return GetFileInFolderResult(
      file: result,
      folderId: folderId,
    );
  }

  Future<drive.File> updateOrCreateFileInFolder({
    required drive.DriveApi api,
    required GoogleDriveConfiguration target,
    required Uint8List data,
  }) async {
    final fileInFolder = await getFileInFolder(api: api, target: target);
    final file = fileInFolder.file?.id;
    final fileId = fileInFolder.file?.id;
    final folderId = fileInFolder.folderId;

    if (file == null) {
      return _createFileInFolder(
        api: api,
        target: target,
        folderId: folderId,
        data: data,
      );
    } else {
      assert(fileId != null && fileId.isNotEmpty);

      if (fileId != null && fileId.isNotEmpty) {
        return _updateFile(
          data,
          api: api,
          fileId: fileId,
          target: target,
        );
      } else {
        throw GoogleError.canNotFindOrCreateFileInFolder();
      }
    }
  }

  Future<Stream<List<int>>?> downloadFileWithId({
    required drive.DriveApi api,
    required String fileId,
  }) async {
    if (fileId.isEmpty) {
      throw const GoogleError.unspecified();
    }

    const fields = 'nextPageToken, files(id, name, md5Checksum, modifiedTime)';

    try {
      final obj = await api.files.get(
        fileId,
        $fields: fields,
        downloadOptions: drive.DownloadOptions.fullMedia,
      );

      if (obj is drive.File) {
        // TODO: ???
        return null;
      } else if (obj is drive.Media) {
        return obj.stream;
      } else {
        throw const GoogleError.unspecified();
      }
    } catch (e) {
      throw GoogleError.unspecified(parentError: e);
    }
  }

  Future<drive.File> _createFileInFolder({
    required drive.DriveApi api,
    required GoogleDriveConfiguration target,
    required String folderId,
    required Uint8List data,
  }) async {
    assert(folderId.isNotEmpty, 'GoogleRepositoryImpl: folderId is empty');

    final media = drive.Media(
      Stream.value(
        List<int>.from(data),
      ),
      data.length,
    );

    final driveFile = drive.File()
      ..name = target.fileName
      ..parents = [folderId];

    try {
      final result = await api.files.create(
        driveFile,
        uploadMedia: media,
      );
      return result;
    } catch (e) {
      throw GoogleError.canNotFindOrCreateFileInFolder(parentError: e);
    }
  }

  Future<drive.File> _updateFile(
    Uint8List data, {
    required drive.DriveApi api,
    required String fileId,
    required GoogleDriveConfiguration target,
  }) async {
    try {
      final newFile = await api.files.update(
        drive.File(
          name: target.fileName,
        ),
        fileId,
        uploadMedia: drive.Media(
          Stream.value(
            List<int>.from(data),
          ),
          data.length,
        ),
      );

      return newFile;
    } catch (e) {
      throw GoogleError.unspecified(parentError: e);
    }
  }

  Future<drive.File?> _findFileInFolder({
    required drive.DriveApi api,
    required String folderId,
    required GoogleDriveConfiguration target,
  }) async {
    try {
      final query = target.searchFileInFolderQuery(folderId);

      final files = await api.files.list(q: query).then(
            (e) => e.files,
          );

      return files?.firstOrNull;
    } catch (e) {
      throw GoogleError.canNotFindOrCreateFileInFolder(parentError: e);
    }
  }

  Future<String> _findOrCreateFolder({
    required drive.DriveApi api,
    required GoogleDriveConfiguration target,
  }) async {
    final result = await _findFolder(api: api, target: target);

    return result != null && result.isNotEmpty
        ? result
        : await _createFolder(api: api, target: target);
  }

  Future<String> _createFolder({
    required drive.DriveApi api,
    required GoogleDriveConfiguration target,
  }) async {
    try {
      final driveFile = drive.File()
        ..name = target.folderName
        ..mimeType = target.folderMimeType;

      final folder = await api.files.create(driveFile);

      final folderId = folder.id;

      if (folderId == null || folderId.isEmpty) {
        throw GoogleError.canNotFindOrCreateFileInFolder();
      }

      return folderId;
    } catch (e) {
      throw GoogleError.canNotFindOrCreateFileInFolder(parentError: e);
    }
  }

  Future<String?> _findFolder({
    required drive.DriveApi api,
    required GoogleDriveConfiguration target,
  }) async {
    try {
      return api.files
          .list(
            q: target.searchFolderQuery,
          )
          .then(
            (e) => e.files?.firstOrNull?.id,
          );
    } catch (e) {
      throw GoogleError.canNotFindOrCreateFileInFolder(parentError: e);
    }
  }
}

extension on GoogleDriveConfiguration {
  String get folderMimeType {
    return 'application/vnd.google-apps.folder';
  }

  String get searchFolderQuery {
    return "mimeType = '$folderMimeType' and name = '$folderName'";
  }

  String searchFileInFolderQuery(String folderId) {
    assert(folderId.isNotEmpty, 'GoogleRepositoryImpl: folderId is empty');
    return "name = '$fileName' and '$folderId' in parents and trashed = false";
  }
}
