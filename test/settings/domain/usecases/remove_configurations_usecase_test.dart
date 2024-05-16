import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/model/local_storage_error.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/settings/domain/remove_configurations_usecase.dart';

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

  final usecase = RemoveConfigurationsUsecase(
    remoteStorageConfigurationProvider: remoteStorageConfigurationProvider,
    pinUsecase: pinUsecase,
    localRepository: localRepository,
    googleRepository: googleRepository,
    checksumChecker: checksumChecker,
  );

  group('RemoveConfigurationsUsecase', () {
    test('remove config', () async {
      final oldConfigurations = RemoteConfigurations(
        configurations: const [
          gitConfiguration,
          googleDriveConfiguration,
        ],
      );

      final newConfigurations = RemoteConfigurations(
        configurations: const [
          gitConfiguration,
        ],
      );

      when(
        () => remoteStorageConfigurationProvider.currentConfiguration,
      ).thenReturn(oldConfigurations);

      const pin = Pin(pinSha512: []);

      when(
        () => pinUsecase.getPinOrThrow(),
      ).thenReturn(pin);

      when(
        () => localRepository.deleteAll(
          target: googleDriveConfiguration.getTarget(pin: pin),
        ),
      ).thenAnswer((_) async {});

      when(
        () => checksumChecker.dropChecksum(
          configuration: googleDriveConfiguration,
        ),
      ).thenAnswer((_) async {});

      when(
        () => googleRepository.logout(),
      ).thenAnswer((_) async {});

      when(
        () => remoteStorageConfigurationProvider.setConfigurations(
          newConfigurations,
        ),
      ).thenAnswer((_) => Future.value());

      when(
        () => pinUsecase.dropPin(),
      ).thenAnswer((_) => Future.value());

      await usecase.execute(googleDriveConfiguration);

      verifyInOrder(
        [
          () => remoteStorageConfigurationProvider.currentConfiguration,
          () => pinUsecase.getPinOrThrow(),
          () => localRepository.deleteAll(
                target: googleDriveConfiguration.getTarget(pin: pin),
              ),
          () => checksumChecker.dropChecksum(
                configuration: googleDriveConfiguration,
              ),
          () => googleRepository.logout(),
          () => remoteStorageConfigurationProvider.setConfigurations(
                newConfigurations,
              ),
          () => pinUsecase.dropPin(),
        ],
      );
    });

    test('throws PinDoesNotMatchError', () async {
      final oldConfigurations = RemoteConfigurations(
        configurations: const [
          gitConfiguration,
          googleDriveConfiguration,
        ],
      );

      final newConfigurations = RemoteConfigurations(
        configurations: const [
          gitConfiguration,
        ],
      );

      when(
        () => remoteStorageConfigurationProvider.currentConfiguration,
      ).thenReturn(oldConfigurations);

      when(
        () => pinUsecase.getPinOrThrow(),
      ).thenThrow(const PinDoesNotMatchError());

      when(
        () => localRepository.deleteCacheFile(target: googleDriveConfiguration),
      ).thenAnswer((_) async {});

      when(
        () => checksumChecker.dropChecksum(
          configuration: googleDriveConfiguration,
        ),
      ).thenAnswer((_) async {});

      when(
        () => googleRepository.logout(),
      ).thenAnswer((_) async {});

      when(
        () => remoteStorageConfigurationProvider.setConfigurations(
          newConfigurations,
        ),
      ).thenAnswer((_) => Future.value());

      when(
        () => pinUsecase.dropPin(),
      ).thenAnswer((_) => Future.value());

      await usecase.execute(googleDriveConfiguration);

      verifyInOrder(
        [
          () => remoteStorageConfigurationProvider.currentConfiguration,
          () => pinUsecase.getPinOrThrow(),
          () => checksumChecker.dropChecksum(
                configuration: googleDriveConfiguration,
              ),
          () => googleRepository.logout(),
          () => remoteStorageConfigurationProvider.setConfigurations(
                newConfigurations,
              ),
          () => pinUsecase.dropPin(),
        ],
      );
    });
  });
}
