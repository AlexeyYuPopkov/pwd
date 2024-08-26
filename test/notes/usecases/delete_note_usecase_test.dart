import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/model/db_error.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/delete_note_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

class MockRemoteConfigurationProvider extends Mock
    implements RemoteConfigurationProvider {}

class MockPinUsecase extends Mock implements PinUsecase {}

class MockRealmLocalRepository extends Mock implements RealmLocalRepository {}

class MockSyncUsecase extends Mock implements SyncUsecase {}

class MockChecksumChecker extends Mock implements ChecksumChecker {}

void main() {
  late RemoteConfigurationProvider configProvider;
  late MockPinUsecase pinUsecase;
  late MockRealmLocalRepository localRepository;
  late MockSyncUsecase syncUsecase;
  late MockChecksumChecker checksumChecker;
  late DeleteNoteUsecase usecase;

  const pin = Pin(pinSha512: []);

  const configuration = GoogleDriveConfiguration(fileName: 'fileName');

  setUp(() {
    configProvider = MockRemoteConfigurationProvider();
    pinUsecase = MockPinUsecase();
    localRepository = MockRealmLocalRepository();
    syncUsecase = MockSyncUsecase();
    checksumChecker = MockChecksumChecker();
    usecase = DeleteNoteUsecase(
      remoteConfigurationProvider: configProvider,
      pinUsecase: pinUsecase,
      localRepository: localRepository,
      syncUsecase: syncUsecase,
      checksumChecker: checksumChecker,
    );
  });

  group('DeleteNoteUsecase', () {
    test('markDeleted', () async {
      const expectedConfig = RemoteConfiguration.google(fileName: 'fileName');
      final expectedConfigs = RemoteConfigurations.createOrThrow(
        configurations: const [expectedConfig],
      );

      when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);

      when(
        () => configProvider.currentConfiguration,
      ).thenReturn(expectedConfigs);

      when(
        () => localRepository.markDeleted(
          '',
          target: configuration.getTarget(pin: pin),
        ),
      ).thenAnswer(
        (_) => Future.value(),
      );

      when(
        () => checksumChecker.dropChecksum(configuration: configuration),
      ).thenAnswer(
        (_) => Future.value(),
      );

      when(
        () => syncUsecase.execute(configuration: configuration, force: true),
      ).thenAnswer(
        (_) => Future.value(),
      );

      await usecase.execute(
        id: '',
        configurationId: expectedConfig.id,
      );

      verifyInOrder([
        () => pinUsecase.getPinOrThrow(),
        () => configProvider.currentConfiguration,
        () => localRepository.markDeleted(
              '',
              target: configuration.getTarget(pin: pin),
            ),
        () => checksumChecker.dropChecksum(configuration: configuration),
        () => syncUsecase.execute(configuration: configuration, force: true),
      ]);
    });

    test('markDeleted - error, wrong config ID', () async {
      const expectedConfig = RemoteConfiguration.google(fileName: 'fileName');
      final expectedConfigs = RemoteConfigurations.createOrThrow(
        configurations: const [expectedConfig],
      );

      when(
        () => configProvider.currentConfiguration,
      ).thenReturn(expectedConfigs);

      when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);

      final result = usecase.execute(
        id: '',
        configurationId: 'wrong id',
      );

      expect(result, throwsA(isA<DbNotFoundError>()));

      verifyInOrder([
        () => pinUsecase.getPinOrThrow(),
        () => configProvider.currentConfiguration,
      ]);
    });
  });
}
