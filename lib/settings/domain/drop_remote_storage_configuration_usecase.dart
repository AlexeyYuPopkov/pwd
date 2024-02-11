import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/notes_repository.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';

final class DropRemoteStorageConfigurationUsecase {
  final RemoteStorageConfigurationProvider remoteStorageConfigurationProvider;
  final NotesRepository notesRepository;
  final PinUsecase pinUsecase;
  final ShouldCreateRemoteStorageFileUsecase
      shouldCreateRemoteStorageFileUsecase;
  final RealmLocalRepository localRepository;
  final GoogleRepository googleRepository;
  final ChecksumChecker checksumChecker;

  const DropRemoteStorageConfigurationUsecase({
    required this.remoteStorageConfigurationProvider,
    required this.notesRepository,
    required this.pinUsecase,
    required this.shouldCreateRemoteStorageFileUsecase,
    required this.localRepository,
    required this.googleRepository,
    required this.checksumChecker,
  });

  Future<void> execute() async {
    final currentConfiguration =
        remoteStorageConfigurationProvider.currentConfiguration;
    await remoteStorageConfigurationProvider.dropConfiguration();

    await Future.wait([
      _clearGitDataIfNeeded(currentConfiguration),
      _clearGoogleDrive(currentConfiguration),
    ]);

    await pinUsecase.dropPin();
  }

  Future<void> _clearGitDataIfNeeded(
    RemoteStorageConfigurations currentConfiguration,
  ) async {
    if (currentConfiguration.hasConfiguration(ConfigurationType.git)) {
      await notesRepository.dropDb();
      shouldCreateRemoteStorageFileUsecase.dropFlag();
    }
  }

  Future<void> _clearGoogleDrive(
    RemoteStorageConfigurations currentConfiguration,
  ) async {
    if (currentConfiguration.hasConfiguration(ConfigurationType.googleDrive)) {
      await googleRepository.logout();
      final pin = pinUsecase.getPinOrThrow();
      await localRepository.deleteAll(key: pin.pinSha512);
      await localRepository.close();
      checksumChecker.dropChecksum();
    }
  }
}
