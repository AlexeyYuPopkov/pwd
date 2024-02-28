import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/settings/domain/save_configurations_usecase.dart';

class MockRemoteStorageConfigurationProvider extends Mock
    implements RemoteConfigurationProvider {}

class MockPinUsecase extends Mock implements PinUsecase {}

class MockRealmLocalRepository extends Mock implements RealmLocalRepository {}

class MockGoogleRepository extends Mock implements GoogleRepository {}

class MockChecksumChecker extends Mock implements ChecksumChecker {}

void main() {
  final remoteStorageConfigurationProvider =
      MockRemoteStorageConfigurationProvider();
  final pinUsecase = MockPinUsecase();
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
    pinUsecase: pinUsecase,
    localRepository: localRepository,
    googleRepository: googleRepository,
    checksumChecker: checksumChecker,
  );

  group('SaveConfigurationsUsecase', () {
    test('save all', () async {
      final oldConfigurations = RemoteConfigurations.empty();

      final newConfigurations = RemoteConfigurations(
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
        () => pinUsecase.dropPin(),
      ).thenAnswer((_) => Future.value());

      await usecase.execute(
        configuration: newConfigurations,
      );

      verifyInOrder(
        [
          () => remoteStorageConfigurationProvider.currentConfiguration,
          () => remoteStorageConfigurationProvider.setConfigurations(
                newConfigurations,
              ),
          () => pinUsecase.dropPin(),
        ],
      );
    });

    test('change all', () async {
      final oldConfigurations = RemoteConfigurations(
        configurations: const [
          gitConfiguration,
          googleDriveConfiguration,
        ],
      );

      const newGitConfiguration = GitConfiguration(
        token: '123',
        repo: '',
        owner: '',
        branch: '',
        fileName: '',
      );

      const newGoogleDriveConfiguration =
          GoogleDriveConfiguration(fileName: '123');

      final newConfigurations = RemoteConfigurations(
        configurations: const [
          newGitConfiguration,
          newGoogleDriveConfiguration,
        ],
      );

      const pin = Pin(pin: '', pinSha512: []);

      when(
        () => remoteStorageConfigurationProvider.currentConfiguration,
      ).thenReturn(
        oldConfigurations,
      );
      //

      when(
        () => checksumChecker.dropChecksum(configuration: gitConfiguration),
      ).thenAnswer((_) => Future.value());

      when(
        () => checksumChecker.dropChecksum(
          configuration: googleDriveConfiguration,
        ),
      ).thenAnswer((_) => Future.value());

      when(
        () => pinUsecase.getPinOrThrow(),
      ).thenReturn(pin);

      when(
        () => pinUsecase.getPinOrThrow(),
      ).thenReturn(pin);

      when(
        () => localRepository.deleteAll(
          target: gitConfiguration.getTarget(pin: pin),
        ),
      ).thenAnswer((_) => Future.value());

      when(
        () => localRepository.deleteAll(
          target: googleDriveConfiguration.getTarget(pin: pin),
        ),
      ).thenAnswer((_) => Future.value());

      when(
        () => googleRepository.logout(),
      ).thenAnswer((_) => Future.value());
      //

      when(
        () => remoteStorageConfigurationProvider.setConfigurations(
          newConfigurations,
        ),
      ).thenAnswer((_) => Future.value());

      when(
        () => pinUsecase.dropPin(),
      ).thenAnswer((_) => Future.value());

      await usecase.execute(
        configuration: newConfigurations,
      );

      verify(() => checksumChecker.dropChecksum(
            configuration: gitConfiguration,
          ));
      verify(() => checksumChecker.dropChecksum(
            configuration: googleDriveConfiguration,
          ));

      verify(() => pinUsecase.getPinOrThrow()).called(2);

      verify(
        () => localRepository.deleteAll(
          target: gitConfiguration.getTarget(pin: pin),
        ),
      );

      verify(
        () => localRepository.deleteAll(
          target: googleDriveConfiguration.getTarget(pin: pin),
        ),
      );

      verify(() => googleRepository.logout());

      verifyInOrder(
        [
          () => remoteStorageConfigurationProvider.currentConfiguration,
          () => remoteStorageConfigurationProvider.setConfigurations(
                newConfigurations,
              ),
          () => pinUsecase.dropPin(),
        ],
      );
    });

    test('drop all', () async {
      final oldConfigurations = RemoteConfigurations(
        configurations: const [
          gitConfiguration,
          googleDriveConfiguration,
        ],
      );

      final newConfigurations = RemoteConfigurations.empty();

      const pin = Pin(pin: '', pinSha512: []);

      when(
        () => remoteStorageConfigurationProvider.currentConfiguration,
      ).thenReturn(
        oldConfigurations,
      );
      //

      when(
        () => checksumChecker.dropChecksum(configuration: gitConfiguration),
      ).thenAnswer((_) => Future.value());

      when(
        () => checksumChecker.dropChecksum(
          configuration: googleDriveConfiguration,
        ),
      ).thenAnswer((_) => Future.value());

      when(
        () => pinUsecase.getPinOrThrow(),
      ).thenReturn(pin);

      when(
        () => pinUsecase.getPinOrThrow(),
      ).thenReturn(pin);

      when(
        () => localRepository.deleteAll(
          target: gitConfiguration.getTarget(pin: pin),
        ),
      ).thenAnswer((_) => Future.value());

      when(
        () => localRepository.deleteAll(
          target: googleDriveConfiguration.getTarget(pin: pin),
        ),
      ).thenAnswer((_) => Future.value());

      when(
        () => googleRepository.logout(),
      ).thenAnswer((_) => Future.value());
      //

      when(
        () => remoteStorageConfigurationProvider.setConfigurations(
          newConfigurations,
        ),
      ).thenAnswer((_) => Future.value());

      when(
        () => pinUsecase.dropPin(),
      ).thenAnswer((_) => Future.value());

      await usecase.execute(
        configuration: newConfigurations,
      );

      verify(() => checksumChecker.dropChecksum(
            configuration: gitConfiguration,
          ));
      verify(() => checksumChecker.dropChecksum(
            configuration: googleDriveConfiguration,
          ));

      verify(() => pinUsecase.getPinOrThrow()).called(2);

      verify(
        () => localRepository.deleteAll(
          target: gitConfiguration.getTarget(pin: pin),
        ),
      );

      verify(
        () => localRepository.deleteAll(
          target: googleDriveConfiguration.getTarget(pin: pin),
        ),
      );

      verify(() => googleRepository.logout());

      verifyInOrder(
        [
          () => remoteStorageConfigurationProvider.currentConfiguration,
          () => remoteStorageConfigurationProvider.setConfigurations(
                newConfigurations,
              ),
          () => pinUsecase.dropPin(),
        ],
      );
    });
  });
}
