import 'dart:io';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/deleted_items_provider.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/local_repository.dart';
import 'package:pwd/notes/domain/model/google_error.dart';
import 'package:pwd/notes/domain/model/google_file.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecase.dart';

final class GoogleSyncUsecase implements SyncDataUsecase {
  final GoogleRepository googleRepository;
  final LocalRepository repository;
  final PinUsecase pinUsecase;
  final ChecksumChecker checksumChecker;
  final DeletedItemsProvider deletedItemsProvider;

  GoogleSyncUsecase({
    required this.googleRepository,
    required this.repository,
    required this.pinUsecase,
    required this.checksumChecker,
    required this.deletedItemsProvider,
  });

  @override
  Future<void> sync() async {
    final file = await googleRepository.getFile();

    if (file == null) {
      final newFile = await _updateFileWithData();

      checksumChecker.setChecksum(newFile.checksum);
    } else {
      final localChecksum = await checksumChecker.getChecksum().then(
            (str) => str ?? '',
          );
      final remoteChecksum = file.checksum;

      if (localChecksum.isNotEmpty && localChecksum == remoteChecksum) {
        return;
      } else {
        await _downloadFileAndSync(file);

        await _updateFileWithData();

        final newChecksum = await googleRepository.getFile().then(
              (e) => e?.checksum,
            );

        checksumChecker.setChecksum(newChecksum ?? '');
      }
    }
  }

  @override
  Future<void> updateRemote() async {
    final _ = await _updateFileWithData();
  }

  Future<void> _downloadFileAndSync(GoogleFile file) async {
    final stream = await googleRepository.downloadFile(file);

    if (stream == null) {
      throw const GoogleError.unspecified();
    } else {
      final bytes = await collectBytes(stream);
      final pin = pinUsecase.getPinOrThrow();
      final deleted = await deletedItemsProvider.getDeletedItems();

      return repository.migrateWithDatabasePath(
        bytes: bytes,
        key: pin.pinSha512,
        deleted: deleted,
      );
    }
  }

  Future<GoogleFile> _updateFileWithData() async {
    final localRealmAsData = await _getLocalRealmAsData();

    return googleRepository.updateRemote(
      localRealmAsData,
    );
  }

  Future<Uint8List> _getLocalRealmAsData() async {
    final pin = pinUsecase.getPinOrThrow();
    final path = await repository.getPath(key: pin.pinSha512);
    return File(path).readAsBytes();
  }
}
