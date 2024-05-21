import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/model/local_storage_error.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';

class RemoveConfigurationsUsecase {
  final RemoteConfigurationProvider _remoteStorageConfigurationProvider;
  final PinUsecase _pinUsecase;
  final RealmLocalRepository _localRepository;
  final GoogleRepository _googleRepository;
  final ChecksumChecker _checksumChecker;

  RemoveConfigurationsUsecase({
    required RemoteConfigurationProvider remoteStorageConfigurationProvider,
    required PinUsecase pinUsecase,
    required RealmLocalRepository localRepository,
    required GoogleRepository googleRepository,
    required ChecksumChecker checksumChecker,
  })  : _remoteStorageConfigurationProvider =
            remoteStorageConfigurationProvider,
        _pinUsecase = pinUsecase,
        _localRepository = localRepository,
        _googleRepository = googleRepository,
        _checksumChecker = checksumChecker;

  Future<void> execute(RemoteConfiguration configuration) async {
    final old = _remoteStorageConfigurationProvider.currentConfiguration;

    await _cleanRelatedData(configuration);

    await _remoteStorageConfigurationProvider.setConfigurations(
      old.removeAndCopy(configuration),
    );
  }

  Future<void> _cleanRelatedData(RemoteConfiguration configuration) async {
    try {
      final pin = _pinUsecase.getPinOrThrow();
      await _localRepository.deleteAll(
        target: configuration.getTarget(pin: pin),
      );
    } catch (e) {
      if (e is PinDoesNotMatchError) {
        await _localRepository.deleteCacheFile(target: configuration);
      } else {
        rethrow;
      }
    } finally {
      await _checksumChecker.dropChecksum(
        configuration: configuration,
      );

      switch (configuration.type) {
        case ConfigurationType.git:
          break;
        case ConfigurationType.googleDrive:
          await _googleRepository.logout();
          break;
      }
    }
  }
}
