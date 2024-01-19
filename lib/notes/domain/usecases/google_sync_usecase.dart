// Sync
import 'dart:io';
import 'package:async/async.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/local_repository.dart';
import 'package:pwd/notes/domain/model/google_error.dart';
import 'package:pwd/notes/domain/model/google_file.dart';

final class GoogleSyncUsecase {
  final GoogleRepository googleSignInUsecase;
  final LocalRepository repository;
  final PinUsecase pinUsecase;

  GoogleSyncUsecase({
    required this.googleSignInUsecase,
    required this.repository,
    required this.pinUsecase,
  });

  Future<void> sync() async {
    final file = await googleSignInUsecase.getFile();

    if (file == null) {
      final _ = await _createFileWithData(); // New Google File
    } else {
      final stream = await googleSignInUsecase.downloadFile(file);

      if (stream == null) {
        throw const GoogleError.unspecified();
      } else {
        final bytes = await collectBytes(stream);
        final pin = pinUsecase.getPinOrThrow();
        return repository.migrateWithDatabasePath(
          bytes: bytes,
          key: pin.pinSha512,
        );
      }
    }
  }

  Future<GoogleFile> _createFileWithData() async {
    final pin = pinUsecase.getPinOrThrow();
    final path = await repository.getPath(key: pin.pinSha512);
    final localRealmAsData = await File(path).readAsBytes();

    return googleSignInUsecase.createFileWithData(
      localRealmAsData,
    );
  }
}
