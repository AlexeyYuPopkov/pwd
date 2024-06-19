import 'dart:convert';
import 'dart:typed_data';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';

import 'package:pwd/notes/domain/git_repository.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/get_db_response.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecases_errors.dart';
import 'package:pwd/notes/domain/usecases/sync_helper.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

final class SyncGitItemUsecaseShaMap {
  static SyncGitItemUsecaseShaMap? _instance;
  final Map<GitConfiguration, String> _shaMap = {};

  SyncGitItemUsecaseShaMap._();

  factory SyncGitItemUsecaseShaMap() =>
      _instance ??= SyncGitItemUsecaseShaMap._();

  void setSha({
    required GitConfiguration configuration,
    required String sha,
  }) =>
      _shaMap[configuration] = sha;

  operator [](GitConfiguration configuration) => _shaMap[configuration];
}

final class SyncGitItemUsecase with SyncHelper implements SyncUsecase {
  static const commitMessage = 'Update notes';
  static const committer = Committer(
    name: 'Alekseii',
    email: 'alexey.yu.popkov@gmail.com',
  );
  final GitRepository remoteRepository;
  @override
  final RealmLocalRepository realmRepository;
  @override
  final PinUsecase pinUsecase;
  final ChecksumChecker checksumChecker;

  final SyncGitItemUsecaseShaMap syncGitItemUsecaseShaMap;

  SyncGitItemUsecase({
    required this.remoteRepository,
    required this.realmRepository,
    required this.pinUsecase,
    required this.checksumChecker,
    required this.syncGitItemUsecaseShaMap,
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

  Future<void> _sync(
      {required RemoteConfiguration configuration, required bool force}) async {
    // TODO: refactor
    switch (configuration) {
      case GitConfiguration():
        break;
      case GoogleDriveConfiguration():
        assert(false);
        return;
    }

    final file = await _getFile(configuration: configuration);

    if (file == null) {
      final newFile = await _updateFileWithData(
        configuration: configuration,
        sha: null,
      );

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
        await _downloadFileAndSync(file: file, configuration: configuration);

        await _updateFileWithData(configuration: configuration, sha: file.sha);

        final newChecksum = await _getFile(
          configuration: configuration,
        ).then(
          (e) => e?.checksum,
        );

        checksumChecker.setChecksum(
          newChecksum ?? '',
          configuration: configuration,
        );
      }
    }
  }
}

// Private
extension on SyncGitItemUsecase {
  Future<GetDbResponse?> _getFile({
    required GitConfiguration configuration,
  }) async {
    final result = await remoteRepository.getFile(configuration: configuration);
    if (result != null) {
      syncGitItemUsecaseShaMap.setSha(
        configuration: configuration,
        sha: result.sha,
      );
    }
    return result;
  }

  Future<PutDbResponse> _updateFileWithData({
    required GitConfiguration configuration,
    required String? sha,
  }) async {
    final localRealmAsData = await getLocalRealmAsData(
      configuration: configuration,
    );

    final contentStr = base64.encode(localRealmAsData);

    final request = PutDbRequest(
      message: SyncGitItemUsecase.commitMessage,
      content: contentStr,
      sha: sha,
      committer: SyncGitItemUsecase.committer,
      branch: configuration.branch,
    );

    return remoteRepository.updateRemote(
      request: request,
      configuration: configuration,
    );
  }

  Future<void> _downloadFileAndSync({
    required GetDbResponse file,
    required GitConfiguration configuration,
  }) async {
    final bytes = await remoteRepository.getRawFile(
      configuration: configuration,
    );
    final pin = pinUsecase.getPinOrThrow();
    final target = configuration.getTarget(pin: pin);

    await realmRepository.mergeWithDatabasePath(
      bytes: Uint8List.fromList(bytes),
      target: target,
    );
  }
}
