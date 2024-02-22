import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/pin_repository.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';

class MockPinRepository extends Mock implements PinRepository {}

void main() {
  const validDuration = Duration(milliseconds: 1);

  late PinRepository pinRepository;
  late PinUsecaseImpl usecase;

  setUp(
    () {
      pinRepository = MockPinRepository();
      usecase = PinUsecaseImpl(
        validDuration: validDuration,
        repository: pinRepository,
      );
    },
  );

  group('PinUsecase', () {
    void testInitialState() {
      when(() => pinRepository.getPin()).thenReturn(const BasePin.empty());

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

    Future<Pin> testSetValidPin() async {
      testInitialState();

      const pin = Pin(pin: '123', pinSha512: []);

      await usecase.setPin(pin);

      expect(usecase.getPin(), isA<Pin>());

      expect(
        usecase.pinStream,
        // emits(isA<Pin>()),
        emitsInOrder([
          isA<Pin>(),
          isA<EmptyPin>(),
        ]),
      );

      return pin;
    }

    test('Test initial state', () => testInitialState());

    test(
      'Test set valid pin and waiting for expiration',
      () => testSetValidPin(),
    );

    test('Test drop pin', () async {
      testInitialState();

      const pin = Pin(pin: '123', pinSha512: []);

      await usecase.setPin(pin);

      when(() => pinRepository.setPin(pin));
      verify(
        () => pinRepository.setPin(pin),
      );

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
