import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/notes_repository.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';

class SaveConfigurationsUsecase {
  final RemoteStorageConfigurationProvider remoteStorageConfigurationProvider;
  final NotesRepository notesRepository;
  final PinUsecase pinUsecase;
  final ShouldCreateRemoteStorageFileUsecase
      shouldCreateRemoteStorageFileUsecase;
  final RealmLocalRepository localRepository;
  final GoogleRepository googleRepository;
  final ChecksumChecker checksumChecker;

  const SaveConfigurationsUsecase({
    required this.remoteStorageConfigurationProvider,
    required this.notesRepository,
    required this.pinUsecase,
    required this.shouldCreateRemoteStorageFileUsecase,
    required this.localRepository,
    required this.googleRepository,
    required this.checksumChecker,
  });

  Future<void> execute({
    required RemoteStorageConfigurations configuration,
    required bool shouldCreateNewGitFile,
  }) async {
    final old = remoteStorageConfigurationProvider.currentConfiguration;

    for (final oldItem in old.configurations) {
      final newItem = configuration.withType(oldItem.type);

      if (newItem == null) {
        await _drop(oldItem.type);
      } else if (newItem != oldItem) {
        await _drop(oldItem.type);
      }
    }

    await remoteStorageConfigurationProvider.setConfigurations(
      configuration,
    );

    if (configuration.hasConfiguration(ConfigurationType.git)) {
      shouldCreateRemoteStorageFileUsecase.setFlag(shouldCreateNewGitFile);
    }

    await pinUsecase.dropPin();
  }

  Future<void> _drop(ConfigurationType type) async {
    switch (type) {
      case ConfigurationType.git:
        await notesRepository.dropDb();
        shouldCreateRemoteStorageFileUsecase.dropFlag();
        break;
      case ConfigurationType.googleDrive:
        await checksumChecker.dropChecksum();
        await googleRepository.logout();
        final pin = pinUsecase.getPinOrThrow();
        await localRepository.deleteAll(key: pin.pinSha512);
        await localRepository.close();
        break;
    }
  }
}
