import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/notes_repository.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/settings/domain/save_configurations_usecase.dart';

class MockRemoteStorageConfigurationProvider extends Mock
    implements RemoteStorageConfigurationProvider {}

class MockNotesRepository extends Mock implements NotesRepository {}

class MockPinUsecase extends Mock implements PinUsecase {}

class MockShouldCreateRemoteStorageFileUsecase extends Mock
    implements ShouldCreateRemoteStorageFileUsecase {}

class MockRealmLocalRepository extends Mock implements RealmLocalRepository {}

class MockGoogleRepository extends Mock implements GoogleRepository {}

class MockChecksumChecker extends Mock implements ChecksumChecker {}

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

  const gitConfiguration = GitConfiguration(
    token: '',
    repo: '',
    owner: '',
    branch: '',
    fileName: '',
  );

  const googleDriveConfiguration = GoogleDriveConfiguration(fileName: '');

  final usecase = SaveConfigurationsUsecase(
    remoteStorageConfigurationProvider: remoteStorageConfigurationProvider,
    notesRepository: notesRepository,
    pinUsecase: pinUsecase,
    shouldCreateRemoteStorageFileUsecase: shouldCreateRemoteStorageFileUsecase,
    localRepository: localRepository,
    googleRepository: googleRepository,
    checksumChecker: checksumChecker,
  );

  group('SaveConfigurationsUsecase', () {
    test('save all', () async {
      final oldConfigurations = RemoteStorageConfigurations.empty();

      final newConfigurations = RemoteStorageConfigurations(
        configurations: const [
          gitConfiguration,
          googleDriveConfiguration,
        ],
      );

      when(
        () => remoteStorageConfigurationProvider.currentConfiguration,
      ).thenReturn(
        oldConfigurations,
      );

      when(
        () => remoteStorageConfigurationProvider.setConfigurations(
          newConfigurations,
        ),
      ).thenAnswer((_) => Future.value());

      when(
        () => shouldCreateRemoteStorageFileUsecase.setFlag(false),
      ).thenReturn(null);

      when(
        () => pinUsecase.dropPin(),
      ).thenAnswer((_) => Future.value());

      await usecase.execute(
        configuration: newConfigurations,
        shouldCreateNewGitFile: false,
      );

      verifyInOrder(
        [
          () => remoteStorageConfigurationProvider.currentConfiguration,
          () => remoteStorageConfigurationProvider.setConfigurations(
                newConfigurations,
              ),
          () => shouldCreateRemoteStorageFileUsecase.setFlag(false),
          () => pinUsecase.dropPin(),
        ],
      );
    });
  });
}

class TestRepo {
  void doSomethingSync(String parameters) {}

  Future<void> doSomething(String parameters) async {}
}

class TestUsecase {
  final TestRepo repo;

  TestUsecase({required this.repo});

  void doSomethingSync(String parameters) {}

  Future<void> execute(String parameters) async {
    repo.doSomethingSync(parameters);
    await repo.doSomething(parameters);
  }
}

class MockTestRepo extends Mock implements TestRepo {}
