import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/data/pin_repository_impl.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';

void main() {
  const validDuration = Duration(seconds: 10);

  late PinUsecaseImpl usecase;

  setUp(
    () {
      usecase = PinUsecaseImpl(
        validDuration: validDuration,
        repository: PinRepositoryImpl(),
      );
    },
  );

  group('PinUsecase', () {
    void testInitialState() {
      // when(() => pinRepository.getPin()).thenReturn(const BasePin.empty());

      expect(usecase.getPin(), isA<EmptyPin>());

      expect(
        () => usecase.getPinOrThrow(),
        throwsA(
          isA<PinUsecaseError>(),
        ),
      );

      expect(
        usecase.pinStream,
        emits(isA<EmptyPin>()),
      );
    }

    test('Test initial state', () => testInitialState());

    Future<Pin> testSetValidPin() async {
      testInitialState();

      const pin = Pin(pinSha512: []);

      await usecase.setPin(pin);

      expect(
        usecase.pinStream,
        emits(isA<Pin>()),
      );

      expectLater(usecase.getPin(), isA<Pin>());

      return pin;
    }

    test(
      'Test set valid pin and waiting for expiration',
      () => testSetValidPin(),
    );

    test('Test drop pin', () async {
      testInitialState();

      const pin = Pin(pinSha512: []);

      await usecase.setPin(pin);

      expect(usecase.getPin(), isA<Pin>());

      await usecase.dropPin();

      expect(
        usecase.pinStream,
        emits(isA<EmptyPin>()),
      );

      expect(usecase.getPin(), isA<EmptyPin>());
    });
  });
}
