import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/note_item_content.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';
import 'package:pwd/notes/domain/usecases/update_note_usecase.dart';

class MockRemoteConfigurationProvider extends Mock
    implements RemoteConfigurationProvider {}

class MockRealmLocalRepository extends Mock implements RealmLocalRepository {}

class MockPinUsecase extends Mock implements PinUsecase {}

class MockChecksumChecker extends Mock implements ChecksumChecker {}

class MockSyncUsecase extends Mock implements SyncUsecase {}

void main() {
  late RemoteConfigurationProvider configProvider;
  late RealmLocalRepository realmLocalRepository;
  late PinUsecase pinUsecase;
  late ChecksumChecker checksumChecker;
  late MockSyncUsecase syncUsecase;

  late UpdateNoteUsecase sut;

  const config = RemoteConfiguration.google(fileName: 'fileName');
  const pin = Pin(pinSha512: []);

  setUp(() {
    configProvider = MockRemoteConfigurationProvider();
    realmLocalRepository = MockRealmLocalRepository();
    pinUsecase = MockPinUsecase();
    checksumChecker = MockChecksumChecker();
    syncUsecase = MockSyncUsecase();

    sut = UpdateNoteUsecase(
      remoteConfigurationProvider: configProvider,
      repository: realmLocalRepository,
      pinUsecase: pinUsecase,
      checksumChecker: checksumChecker,
      syncUsecase: syncUsecase,
    );
  });

  group('UpdateNoteUsecase', () {
    test(
      'New note',
      () async {
        when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);

        const expectedConfig = RemoteConfiguration.google(fileName: 'fileName');
        final expectedConfigs = RemoteConfigurations.createOrThrow(
          configurations: const [expectedConfig],
        );

        when(
          () => configProvider.currentConfiguration,
        ).thenReturn(expectedConfigs);

        final newNote = BaseNoteItem.newItem();

        expect(newNote, isA<NewNoteItem>());

        when(
          () => pinUsecase.getPinOrThrow(),
        ).thenReturn(pin);

        when(
          () => realmLocalRepository.createNote(
            newNote as NewNoteItem,
            target: config.getTarget(pin: pin),
          ),
        ).thenAnswer((_) async {});

        when(
          () => checksumChecker.dropChecksum(
            configuration: config,
          ),
        ).thenAnswer((_) async {});

        when(
          () => syncUsecase.execute(
            configuration: config,
            force: false,
          ),
        ).thenAnswer((_) async {});

        await sut.execute(newNote, configurationId: expectedConfig.id);

        verifyInOrder(
          [
            () => pinUsecase.getPinOrThrow(),
            () => configProvider.currentConfiguration,
            () => realmLocalRepository.createNote(
                  newNote as NewNoteItem,
                  target: config.getTarget(pin: pin),
                ),
            () => checksumChecker.dropChecksum(
                  configuration: config,
                ),
            () => syncUsecase.execute(
                  configuration: config,
                  force: false,
                ),
          ],
        );
      },
    );

    test(
      'Update note',
      () async {
        final note = NoteItem(
          id: '',
          content: const NoteContent(
            items: [
              NoteContentItem(text: 'text'),
            ],
          ),
          updated: TimestampHelper.timestampForDate(DateTime.now()),
        );

        when(
          () => pinUsecase.getPinOrThrow(),
        ).thenReturn(pin);

        const expectedConfig = RemoteConfiguration.google(fileName: 'fileName');
        final expectedConfigs = RemoteConfigurations.createOrThrow(
          configurations: const [expectedConfig],
        );

        when(
          () => configProvider.currentConfiguration,
        ).thenReturn(expectedConfigs);

        when(
          () => realmLocalRepository.updateNote(
            note,
            target: config.getTarget(pin: pin),
          ),
        ).thenAnswer((_) async {});

        when(
          () => checksumChecker.dropChecksum(
            configuration: config,
          ),
        ).thenAnswer((_) async {});

        when(
          () => syncUsecase.execute(
            configuration: config,
            force: false,
          ),
        ).thenAnswer((_) async {});

        await sut.execute(note, configurationId: expectedConfig.id);

        verifyInOrder(
          [
            () => pinUsecase.getPinOrThrow(),
            () => configProvider.currentConfiguration,
            () => realmLocalRepository.updateNote(
                  note,
                  target: config.getTarget(pin: pin),
                ),
            () => checksumChecker.dropChecksum(
                  configuration: config,
                ),
            () => syncUsecase.execute(
                  configuration: config,
                  force: false,
                ),
          ],
        );
      },
    );
  });
}
