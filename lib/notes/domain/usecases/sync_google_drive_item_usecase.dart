import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
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
  Future<void> sync({required RemoteConfiguration configuration}) async {
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

      checksumChecker.setChecksum(
        newFile.checksum,
        configuration: configuration,
      );
    } else {
      final localChecksum = await checksumChecker
          .getChecksum(
            configuration: configuration,
          )
          .then(
            (str) => str ?? '',
          );

      final remoteChecksum = file.checksum;

      if (localChecksum.isNotEmpty && localChecksum == remoteChecksum) {
        return;
      } else {
        await _downloadFileAndSync(file, configuration: configuration);

        await _updateFileWithData(configuration: configuration);

        final newChecksum = await googleRepository
            .getFile(
              target: configuration,
            )
            .then(
              (e) => e?.checksum,
            );

        checksumChecker.setChecksum(
          newChecksum ?? '',
          configuration: configuration,
        );
      }
    }
  }

  @override
  Future<void> updateRemote({
    required RemoteConfiguration configuration,
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

  Future<void> _downloadFileAndSync(
    GoogleDriveFile file, {
    required RemoteConfiguration configuration,
  }) async {
    final stream = await googleRepository.downloadFile(file);

    if (stream == null) {
      throw const GoogleError.unspecified();
    } else {
      final bytes = await collectBytes(stream);
      final pin = pinUsecase.getPinOrThrow();
      final deleted = await deletedItemsProvider.getDeletedItems(
        configuration: configuration,
      );

      return realmRepository.migrateWithDatabasePath(
        bytes: bytes,
        target: configuration.getTarget(pin: pin),
        deleted: deleted,
      );
    }
  }

  Future<GoogleDriveFile> _updateFileWithData({
    required GoogleDriveConfiguration configuration,
  }) async {
    final localRealmAsData = await _getLocalRealmAsData(
      configuration: configuration,
    );

    return googleRepository.updateRemote(
      localRealmAsData,
      target: configuration,
    );
  }

  Future<Uint8List> _getLocalRealmAsData({
    required RemoteConfiguration configuration,
  }) async {
    final pin = pinUsecase.getPinOrThrow();
    return realmRepository.readAsBytes(
      target: configuration.getTarget(pin: pin),
    );
  }
}
