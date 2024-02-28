import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/delete_note_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

class MockPinUsecase extends Mock implements PinUsecase {}

class MockRealmLocalRepository extends Mock implements RealmLocalRepository {}

class MockSyncUsecase extends Mock implements SyncUsecase {}

void main() {
  final pinUsecase = MockPinUsecase();
  final localRepository = MockRealmLocalRepository();
  final syncUsecase = MockSyncUsecase();

  const pin = Pin(pinSha512: []);

  const configuration = GoogleDriveConfiguration(fileName: 'fileName');

  group('DeleteNoteUsecase', () {
    test('markDeleted', () async {
      final usecase = DeleteNoteUsecase(
        pinUsecase: pinUsecase,
        localRepository: localRepository,
        syncUsecase: syncUsecase,
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
        () => syncUsecase.sync(configuration: configuration),
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
        () => syncUsecase.sync(configuration: configuration),
      ]);
    });
  });
}
