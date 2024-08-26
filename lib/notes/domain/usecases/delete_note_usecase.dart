import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/model/db_error.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

class DeleteNoteUsecase {
  final RemoteConfigurationProvider _configProvider;
  final PinUsecase _pinUsecase;
  final RealmLocalRepository _localRepository;
  final SyncUsecase _syncUsecase;
  final ChecksumChecker _checksumChecker;

  const DeleteNoteUsecase({
    required RemoteConfigurationProvider remoteConfigurationProvider,
    required PinUsecase pinUsecase,
    required RealmLocalRepository localRepository,
    required SyncUsecase syncUsecase,
    required ChecksumChecker checksumChecker,
  })  : _configProvider = remoteConfigurationProvider,
        _pinUsecase = pinUsecase,
        _localRepository = localRepository,
        _syncUsecase = syncUsecase,
        _checksumChecker = checksumChecker;

  Future<void> execute({
    required String id,
    required String configurationId,
  }) async {
    final pin = _pinUsecase.getPinOrThrow();

    final configuration = _configProvider.currentConfiguration.withId(
      configurationId,
    );

    if (configuration == null || configuration.id.isEmpty) {
      throw const DbError.notFound();
    }

    await _localRepository.markDeleted(
      id,
      target: configuration.getTarget(pin: pin),
    );
    await _checksumChecker.dropChecksum(configuration: configuration);
    await _syncUsecase.execute(configuration: configuration, force: true);
  }
}
