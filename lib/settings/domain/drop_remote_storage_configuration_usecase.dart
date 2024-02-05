import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';
import 'package:pwd/notes/domain/local_repository.dart';
import 'package:pwd/notes/domain/notes_repository.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';

final class DropRemoteStorageConfigurationUsecase {
  final RemoteStorageConfigurationProvider remoteStorageConfigurationProvider;
  final NotesRepository notesRepository;
  final PinUsecase pinUsecase;
  final ShouldCreateRemoteStorageFileUsecase
      shouldCreateRemoteStorageFileUsecase;
  final LocalRepository localRepository;

  const DropRemoteStorageConfigurationUsecase({
    required this.remoteStorageConfigurationProvider,
    required this.notesRepository,
    required this.pinUsecase,
    required this.shouldCreateRemoteStorageFileUsecase,
    required this.localRepository,
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
      final pin = pinUsecase.getPinOrThrow();
      await localRepository.deleteAll(key: pin.pinSha512);
    }
  }
}