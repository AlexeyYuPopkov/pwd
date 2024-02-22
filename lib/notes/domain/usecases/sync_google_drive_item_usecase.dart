import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/deleted_items_provider.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/model/google_error.dart';
import 'package:pwd/notes/domain/model/google_drive_file.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

final class SyncGoogleDriveItemUsecase implements SyncUsecase {
  final GoogleRepository googleRepository;
  final RealmLocalRepository realmRepository;
  final PinUsecase pinUsecase;
  final ChecksumChecker checksumChecker;
  final DeletedItemsProvider deletedItemsProvider;

  SyncGoogleDriveItemUsecase({
    required this.googleRepository,
    required this.realmRepository,
    required this.pinUsecase,
    required this.checksumChecker,
    required this.deletedItemsProvider,
  });

  @override
  Future<void> sync({required RemoteStorageConfiguration configuration}) async {
    // TODO: refactor
    switch (configuration) {
      case GitConfiguration():
        assert(false);
        return;
      case GoogleDriveConfiguration():
        break;
    }

    final file = await googleRepository.getFile(target: configuration);

    if (file == null) {
      final newFile = await _updateFileWithData(configuration: configuration);

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

        await _updateFileWithData(configuration: configuration);

        final newChecksum = await googleRepository
            .getFile(
              target: configuration,
            )
            .then(
              (e) => e?.checksum,
            );

        checksumChecker.setChecksum(newChecksum ?? '');
      }
    }
  }

  @override
  Future<void> updateRemote({
    required RemoteStorageConfiguration configuration,
  }) async {
    // TODO: refactor
    switch (configuration) {
      case GitConfiguration():
        assert(false);
        return;
      case GoogleDriveConfiguration():
        break;
    }
    final _ = await _updateFileWithData(configuration: configuration);
  }

  Future<void> _downloadFileAndSync(GoogleDriveFile file) async {
    final stream = await googleRepository.downloadFile(file);

    if (stream == null) {
      throw const GoogleError.unspecified();
    } else {
      final bytes = await collectBytes(stream);
      final pin = pinUsecase.getPinOrThrow();
      final deleted = await deletedItemsProvider.getDeletedItems();

      return realmRepository.migrateWithDatabasePath(
        bytes: bytes,
        key: pin.pinSha512,
        deleted: deleted,
      );
    }
  }

  Future<GoogleDriveFile> _updateFileWithData({
    required GoogleDriveConfiguration configuration,
  }) async {
    final localRealmAsData = await _getLocalRealmAsData();

    return googleRepository.updateRemote(
      localRealmAsData,
      target: configuration,
    );
  }

  Future<Uint8List> _getLocalRealmAsData() async {
    final pin = pinUsecase.getPinOrThrow();
    return realmRepository.readAsBytes(key: pin.pinSha512);
  }
}
