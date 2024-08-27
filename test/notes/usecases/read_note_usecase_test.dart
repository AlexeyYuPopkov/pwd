import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/data/remote_configuration_provider_impl.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/model/db_error.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/note_item_content.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/read_note_usecase.dart';

class MockRealmLocalRepository extends Mock implements RealmLocalRepository {}

class MockPinUsecase extends Mock implements PinUsecase {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late ReadNoteUsecase sut;

  late FlutterSecureStorage flutterSecureStorage;
  late RemoteConfigurationProvider remoteConfigurationProvider;
  late MockPinUsecase mockPinUsecase;
  late MockRealmLocalRepository localRepository;

  late StreamSubscription? configSubscription;

  setUp(() {
    flutterSecureStorage = MockFlutterSecureStorage();

    remoteConfigurationProvider = RemoteConfigurationProviderImpl(
      storage: SecureStorageBox(flutterSecureStorage),
    );
    mockPinUsecase = MockPinUsecase();
    localRepository = MockRealmLocalRepository();

    sut = ReadNoteUsecase(
      remoteConfigurationProvider: remoteConfigurationProvider,
      repository: localRepository,
      pinUsecase: mockPinUsecase,
    );
  });

  tearDown(() {
    configSubscription?.cancel();
    configSubscription = null;
  });

  const jsonSharedPreferencesKey =
      'RemoteStorageConfigurationProvider.RemoteStorageConfigurationKey';
  const jsonSharedPreferencesStr =
      r'{"configurations":[{"type":"googleDrive","value":{"fileName":"fileName"}}]}';
  const config = RemoteConfiguration.google(fileName: 'fileName');
  const pin = Pin(pinSha512: []);

  group('ReadNoteUsecase', () {
    test('read a note', () async {
      when(
        () => flutterSecureStorage.read(key: jsonSharedPreferencesKey),
      ).thenAnswer((_) async {
        return jsonSharedPreferencesStr;
      });

      final completer = Completer<bool>();

      configSubscription =
          remoteConfigurationProvider.configuration.listen((e) {
        if (e.configurations.isNotEmpty) {
          completer.complete(true);
        }
      });

      final isRemoteConfigurationProviderReady = await completer.future;

      expect(isRemoteConfigurationProviderReady, true);

      when(() => mockPinUsecase.getPinOrThrow()).thenReturn(pin);

      final target = config.getTarget(pin: pin);

      when(
        () => localRepository.readNote('noteId', target: target),
      ).thenAnswer((_) async {
        return const NoteItem(
          id: 'noteId',
          content: NoteContent(items: []),
          updated: 0,
        );
      });

      final result = await sut.execute(
        configId: config.id,
        noteId: 'noteId',
      );

      expect(result, isA<NoteItem>());
    });

    test('note not exist', () async {
      when(
        () => flutterSecureStorage.read(key: jsonSharedPreferencesKey),
      ).thenAnswer((_) async {
        return jsonSharedPreferencesStr;
      });

      final completer = Completer<bool>();

      configSubscription =
          remoteConfigurationProvider.configuration.listen((e) {
        if (e.configurations.isNotEmpty) {
          completer.complete(true);
        }
      });

      final isRemoteConfigurationProviderReady = await completer.future;

      expect(isRemoteConfigurationProviderReady, true);

      when(() => mockPinUsecase.getPinOrThrow()).thenReturn(pin);

      final target = config.getTarget(pin: pin);

      when(
        () => localRepository.readNote('noteId', target: target),
      ).thenAnswer((_) async => null);

      final result = sut.execute(
        configId: config.id,
        noteId: 'noteId',
      );

      expect(result, throwsA(isA<DbNotFoundError>()));
    });
  });
}
