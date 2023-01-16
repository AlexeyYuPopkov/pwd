import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/pin_repository.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';

class MockPinRepository extends Mock implements PinRepository {}

void main() {
  late final PinRepository pinRepo = MockPinRepository();

  void testIteration(String str, String pin) {
    final usecase = HashUsecase(pinRepository: pinRepo);

    final pinHash = usecase.pinHash(pin);
    final expectedPin = BasePin.pin(pin: pinHash);

    when(
      () => pinRepo.getPin(),
    ).thenReturn(expectedPin);

    final encoded = usecase.encode(str);

    final decoded = usecase.tryDecode(encoded);

    expect(encoded.isNotEmpty, true);
    expect(decoded == str, true);
  }

  test('HashUsecase', () {
    const values = [
      MapEntry(
        'Pass@word1',
        '01234567890abcdefg',
      ),
      MapEntry(
        'Pass@word1. Lorem ipsum dolor sit amet, consectetur adipiscing elit',
        '01234567890abcdefg',
      ),
      MapEntry(
        'Pass@word1. Lorem ipsum dolor sit amet, consectetur adipiscing elit',
        'Pass@word1. Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      ),
      MapEntry(
        '1',
        'Pass@word1. Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      ),
      MapEntry(
        '',
        'Pass@word1. Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      ),
    ];

    for (final item in values) {
      testIteration(item.value, item.key);
    }
  });

  test('HashUsecase - Exception: Empty Pin', () {
    final usecase = HashUsecase(pinRepository: pinRepo);

    const expectedPin = BasePin.empty();

    when(
      () => pinRepo.getPin(),
    ).thenReturn(expectedPin);

    expect(
      () => usecase.encode('Lorem ipsum dolor sit amet'),
      throwsA(
        isA<HashUsecaseEmptyPinError>(),
      ),
    );

    expect(
      () => usecase.tryDecode('Lorem ipsum dolor sit amet'),
      throwsA(
        isA<HashUsecaseEmptyPinError>(),
      ),
    );
  });

  test('HashUsecase - Exception: Wrong pin length', () {
    final usecase = HashUsecase(pinRepository: pinRepo);

    final expectedPin = BasePin.pin(pin: '12345');

    when(
      () => pinRepo.getPin(),
    ).thenReturn(expectedPin);

    expect(
      () => usecase.encode('Lorem ipsum dolor sit amet'),
      throwsA(
        isA<HashUsecaseWrongPinLengthError>(),
      ),
    );

    expect(
      () => usecase.tryDecode('Lorem ipsum dolor sit amet'),
      throwsA(
        isA<HashUsecaseWrongPinLengthError>(),
      ),
    );
  });
}
