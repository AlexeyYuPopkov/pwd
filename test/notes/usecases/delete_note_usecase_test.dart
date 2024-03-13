import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/delete_note_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

class MockPinUsecase extends Mock implements PinUsecase {}

class MockRealmLocalRepository extends Mock implements RealmLocalRepository {}

class MockSyncUsecase extends Mock implements SyncUsecase {}

class MockChecksumChecker extends Mock implements ChecksumChecker {}

void main() {
  final pinUsecase = MockPinUsecase();
  final localRepository = MockRealmLocalRepository();
  final syncUsecase = MockSyncUsecase();
  final checksumChecker = MockChecksumChecker();

  const pin = Pin(pinSha512: []);

  const configuration = GoogleDriveConfiguration(fileName: 'fileName');

  group('DeleteNoteUsecase', () {
    test('markDeleted', () async {
      final usecase = DeleteNoteUsecase(
        pinUsecase: pinUsecase,
        localRepository: localRepository,
        syncUsecase: syncUsecase,
        checksumChecker: checksumChecker,
      );

      when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);

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
        configuration: configuration,
      );

      verifyInOrder([
        () => pinUsecase.getPinOrThrow(),
        () => localRepository.markDeleted(
              '',
              target: configuration.getTarget(pin: pin),
            ),
        () => checksumChecker.dropChecksum(configuration: configuration),
        () => syncUsecase.execute(configuration: configuration, force: true),
      ]);
    });
  });
}
