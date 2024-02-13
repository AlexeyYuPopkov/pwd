import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/workflowexecutions/v1.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/google_repository.dart';

import 'package:pwd/notes/domain/notes_repository.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/settings/domain/drop_remote_storage_configuration_usecase.dart';

@GenerateNiceMocks(
  [
    MockSpec<RemoteStorageConfigurationProvider>(),
    MockSpec<NotesRepository>(),
    MockSpec<PinUsecase>(),
    MockSpec<ShouldCreateRemoteStorageFileUsecase>(),
    MockSpec<RealmLocalRepository>(),
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

  final localRepository = MockRealmLocalRepository();

  final googleRepository = MockGoogleRepository();

  final checksumChecker = MockChecksumChecker();

  group(
    'DropRemoteStorageConfigurationUsecaseTest',
    () {
      final pin = Pin(
        pin: '',
        pinSha512: [],
        creationDate: DateTime.now(),
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

          final veryficationsStart = verifyInOrder([
            remoteStorageConfigurationProvider.currentConfiguration,
            remoteStorageConfigurationProvider.dropConfiguration(),
          ]);

          final veryficationsGit = verifyInOrder([
            notesRepository.dropDb(),
            shouldCreateRemoteStorageFileUsecase.dropFlag(),
          ]);

          final veryficationsEnd = verifyInOrder([
            pinUsecase.dropPin(),
          ]);

          expect(veryficationsStart.length, 2);
          expect(veryficationsGit.length, 2);
          expect(veryficationsEnd.length, 1);

          verifyNever(pinUsecase.getPinOrThrow());
          verifyNever(localRepository.deleteAll(key: pin.pinSha512));
          verifyNever(localRepository.close());
          verifyNever(googleRepository.logout());
          verifyNever(checksumChecker.dropChecksum());
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

          final veryficationsStart = verifyInOrder([
            remoteStorageConfigurationProvider.currentConfiguration,
            remoteStorageConfigurationProvider.dropConfiguration(),
          ]);

          final veryficationsGoogleDrive = verifyInOrder([
            googleRepository.logout(),
            pinUsecase.getPinOrThrow(),
            localRepository.deleteAll(key: pin.pinSha512),
            localRepository.close(),
            checksumChecker.dropChecksum(),
          ]);

          final veryficationsEnd = verifyInOrder([
            pinUsecase.dropPin(),
          ]);

          expect(veryficationsStart.length, 2);
          expect(veryficationsGoogleDrive.length, 5);
          expect(veryficationsEnd.length, 1);

          verifyNever(notesRepository.dropDb());
          verifyNever(shouldCreateRemoteStorageFileUsecase.dropFlag());
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

          final veryficationsStart = verifyInOrder([
            remoteStorageConfigurationProvider.currentConfiguration,
            remoteStorageConfigurationProvider.dropConfiguration(),
          ]);

          final veryficationsGit = verifyInOrder([
            notesRepository.dropDb(),
            shouldCreateRemoteStorageFileUsecase.dropFlag(),
          ]);

          final veryficationsGoogleDrive = verifyInOrder([
            googleRepository.logout(),
            pinUsecase.getPinOrThrow(),
            localRepository.deleteAll(key: pin.pinSha512),
            localRepository.close(),
            checksumChecker.dropChecksum(),
          ]);

          final veryficationsEnd = verifyInOrder([
            pinUsecase.dropPin(),
          ]);

          expect(veryficationsStart.length, 2);
          expect(veryficationsGit.length, 2);
          expect(veryficationsGoogleDrive.length, 5);
          expect(veryficationsEnd.length, 1);
        },
      );

      test(
        'verify throws',
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
          ).thenThrow(_Exception());

          final result = usecase.execute().then(
            (value) {
              final veryfications = verifyInOrder([
                remoteStorageConfigurationProvider.dropConfiguration(),
                notesRepository.dropDb(),
                shouldCreateRemoteStorageFileUsecase.dropFlag(),
                pinUsecase.getPinOrThrow(),
                localRepository.deleteAll(key: pin.pinSha512),
                localRepository.close(),
                googleRepository.logout(),
                pinUsecase.dropPin(),
                checksumChecker.dropChecksum(),
              ]);

              expect(veryfications.length, 8);
            },
          );

          expect(result, throwsA(isA<_Exception>()));
        },
      );
    },
  );
}

final class _Exception extends Exception {}
