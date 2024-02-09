import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/local_repository.dart';
import 'package:pwd/notes/domain/notes_repository.dart';
import 'package:pwd/settings/domain/drop_remote_storage_configuration_usecase.dart';

@GenerateNiceMocks(
  [
    MockSpec<RemoteStorageConfigurationProvider>(),
    MockSpec<NotesRepository>(),
    MockSpec<PinUsecase>(),
    MockSpec<ShouldCreateRemoteStorageFileUsecase>(),
    MockSpec<LocalRepository>(),
    MockSpec<GoogleRepository>(),
    MockSpec<ChecksumChecker>(),
  ],
)
import 'drop_remote_storage_configuration_usecase_test.mocks.dart';

void main() {
  final remoteStorageConfigurationProvider =
      MockRemoteStorageConfigurationProvider();
  final notesRepository = MockNotesRepository();
  final pinUsecase = MockPinUsecase();
  final shouldCreateRemoteStorageFileUsecase =
      MockShouldCreateRemoteStorageFileUsecase();

  final localRepository = MockLocalRepository();

  final googleRepository = MockGoogleRepository();

  final checksumChecker = MockChecksumChecker();

  group(
    'DropRemoteStorageConfigurationUsecaseTest',
    () {
      final pin = Pin(
        pin: '',
        pinSha512: [],
      );

      const gitConfiguration = GitConfiguration(
        token: '',
        repo: '',
        owner: '',
        branch: '',
        fileName: '',
      );

      const googleDriveConfiguration = GoogleDriveConfiguration(fileName: '');

      test(
        'Verify git related methods called',
        () async {
          final usecase = DropRemoteStorageConfigurationUsecase(
            remoteStorageConfigurationProvider:
                remoteStorageConfigurationProvider,
            notesRepository: notesRepository,
            pinUsecase: pinUsecase,
            shouldCreateRemoteStorageFileUsecase:
                shouldCreateRemoteStorageFileUsecase,
            localRepository: localRepository,
            googleRepository: googleRepository,
            checksumChecker: checksumChecker,
          );

          final configurations = RemoteStorageConfigurations(
            configurations: const [
              gitConfiguration,
            ],
          );

          provideDummy(configurations);
          provideDummy(pin);

          when(
            remoteStorageConfigurationProvider.currentConfiguration,
          ).thenReturn(configurations);

          when(
            pinUsecase.getPinOrThrow(),
          ).thenReturn(pin);

          await usecase.execute();

          verify(remoteStorageConfigurationProvider.dropConfiguration());
          verify(notesRepository.dropDb());
          verify(shouldCreateRemoteStorageFileUsecase.dropFlag());
          verifyNever(pinUsecase.getPinOrThrow());
          verifyNever(localRepository.deleteAll(key: pin.pinSha512));
          verifyNever(googleRepository.logout());
          verifyNever(checksumChecker.dropChecksum());

          verify(pinUsecase.dropPin());
        },
      );

      test(
        'Verify Google Drive related methods called',
        () async {
          final usecase = DropRemoteStorageConfigurationUsecase(
            remoteStorageConfigurationProvider:
                remoteStorageConfigurationProvider,
            notesRepository: notesRepository,
            pinUsecase: pinUsecase,
            shouldCreateRemoteStorageFileUsecase:
                shouldCreateRemoteStorageFileUsecase,
            localRepository: localRepository,
            googleRepository: googleRepository,
            checksumChecker: checksumChecker,
          );

          final configurations = RemoteStorageConfigurations(
            configurations: const [
              googleDriveConfiguration,
            ],
          );

          provideDummy(configurations);
          provideDummy(pin);

          when(
            remoteStorageConfigurationProvider.currentConfiguration,
          ).thenReturn(configurations);

          when(
            pinUsecase.getPinOrThrow(),
          ).thenReturn(pin);

          await usecase.execute();

          verify(remoteStorageConfigurationProvider.dropConfiguration());
          verifyNever(notesRepository.dropDb());
          verifyNever(shouldCreateRemoteStorageFileUsecase.dropFlag());
          verify(pinUsecase.getPinOrThrow());
          verify(localRepository.deleteAll(key: pin.pinSha512));
          verify(googleRepository.logout());
          verify(pinUsecase.dropPin());
          verify(checksumChecker.dropChecksum());
        },
      );

      test(
        'Verify Git and Google Drive related methods called',
        () async {
          final usecase = DropRemoteStorageConfigurationUsecase(
            remoteStorageConfigurationProvider:
                remoteStorageConfigurationProvider,
            notesRepository: notesRepository,
            pinUsecase: pinUsecase,
            shouldCreateRemoteStorageFileUsecase:
                shouldCreateRemoteStorageFileUsecase,
            localRepository: localRepository,
            googleRepository: googleRepository,
            checksumChecker: checksumChecker,
          );

          final configurations = RemoteStorageConfigurations(
            configurations: const [
              gitConfiguration,
              googleDriveConfiguration,
            ],
          );

          provideDummy(configurations);
          provideDummy(pin);

          when(
            remoteStorageConfigurationProvider.currentConfiguration,
          ).thenReturn(configurations);

          when(
            pinUsecase.getPinOrThrow(),
          ).thenReturn(pin);

          await usecase.execute();

          verify(remoteStorageConfigurationProvider.dropConfiguration());
          verify(notesRepository.dropDb());
          verify(shouldCreateRemoteStorageFileUsecase.dropFlag());
          verify(pinUsecase.getPinOrThrow());
          verify(localRepository.deleteAll(key: pin.pinSha512));
          verify(googleRepository.logout());
          verify(pinUsecase.dropPin());
          verify(checksumChecker.dropChecksum());
        },
      );
    },
  );
}
