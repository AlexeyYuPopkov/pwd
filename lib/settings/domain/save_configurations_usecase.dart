import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';

import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/model/local_storage_error.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';

class SaveConfigurationsUsecase {
  final RemoteConfigurationProvider remoteStorageConfigurationProvider;
  final PinUsecase pinUsecase;
  final RealmLocalRepository localRepository;
  final GoogleRepository googleRepository;
  final ChecksumChecker checksumChecker;

  const SaveConfigurationsUsecase({
    required this.remoteStorageConfigurationProvider,
    required this.pinUsecase,
    required this.localRepository,
    required this.googleRepository,
    required this.checksumChecker,
  });

  Future<void> execute({
    required RemoteConfigurations configuration,
  }) async {
    final old = remoteStorageConfigurationProvider.currentConfiguration;

    for (final oldItem in old.configurations) {
      final newItem = configuration.withType(oldItem.type);

      if (newItem == null) {
        await _drop(oldItem);
      } else if (newItem != oldItem) {
        await _drop(oldItem);
      }
    }

    await remoteStorageConfigurationProvider.setConfigurations(
      configuration,
    );

    await pinUsecase.dropPin();
  }

  Future<void> _drop(RemoteConfiguration configuration) async {
    try {
      final pin = pinUsecase.getPinOrThrow();
      await localRepository.deleteAll(
        target: configuration.getTarget(pin: pin),
      );
    } catch (e) {
      if (e is PinDoesNotMatchError) {
        await localRepository.deleteCacheFile(target: configuration);
      } else {
        rethrow;
      }
    } finally {
      await checksumChecker.dropChecksum(
        configuration: configuration,
      );

      switch (configuration.type) {
        case ConfigurationType.git:
          break;
        case ConfigurationType.googleDrive:
          await googleRepository.logout();

          break;
      }
    }

    // PinDoesNotMatchError
  }
}
