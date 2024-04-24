import 'package:async/async.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/model/google_error.dart';
import 'package:pwd/notes/domain/model/google_drive_file.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecases_errors.dart';
import 'package:pwd/notes/domain/usecases/sync_helper.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

final class SyncGoogleDriveItemUsecase with SyncHelper implements SyncUsecase {
  final GoogleRepository remoteRepository;
  @override
  final RealmLocalRepository realmRepository;
  @override
  final PinUsecase pinUsecase;
  final ChecksumChecker checksumChecker;

  SyncGoogleDriveItemUsecase({
    required this.remoteRepository,
    required this.realmRepository,
    required this.pinUsecase,
    required this.checksumChecker,
  });

  @override
  Future<void> execute(
      {required RemoteConfiguration configuration, required bool force}) async {
    try {
      await _sync(configuration: configuration, force: force);
    } catch (e) {
      throw SyncDataError.unknown(parentError: e);
    }
  }

  Future<void> _sync({
    required RemoteConfiguration configuration,
    required bool force,
  }) async {
    // TODO: refactor
    switch (configuration) {
      case GitConfiguration():
        assert(false);
        return;
      case GoogleDriveConfiguration():
        break;
    }

    final file = await remoteRepository.getFile(target: configuration);

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
      if (localChecksum.isNotEmpty &&
          localChecksum == remoteChecksum &&
          force == false) {
        return;
      } else {
        await _downloadFileAndSync(file, configuration: configuration);

        await _updateFileWithData(configuration: configuration);

        final newChecksum = await remoteRepository
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

  Future<void> _downloadFileAndSync(
    GoogleDriveFile file, {
    required RemoteConfiguration configuration,
  }) async {
    final stream = await remoteRepository.downloadFile(file);

    if (stream == null) {
      throw const GoogleError.unspecified();
    } else {
      final bytes = await collectBytes(stream);
      final pin = pinUsecase.getPinOrThrow();

      final target = configuration.getTarget(pin: pin);

      await realmRepository.mergeWithDatabasePath(
        bytes: bytes,
        target: target,
      );

      return realmRepository.creanDeletedIfNeeded(target: target);
    }
  }

  Future<GoogleDriveFile> _updateFileWithData({
    required GoogleDriveConfiguration configuration,
  }) async {
    final localRealmAsData = await getLocalRealmAsData(
      configuration: configuration,
    );

    return remoteRepository.updateRemote(
      localRealmAsData,
      configuration: configuration,
    );
  }
}
