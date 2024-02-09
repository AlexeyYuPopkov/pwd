import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';

void main() {
  void testIteration(String str, BasePin pin) {
    const usecase = HashUsecase();

    final expectedPin = pin;

    final encoded = usecase.encode(str, expectedPin);

    final decoded = usecase.tryDecode(encoded, expectedPin);

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
      testIteration(
        item.value,
        Pin(
          pin: const HashUsecase().pinHash(item.key),
          pinSha512: const [],
          creationDate: DateTime.now(),
        ),
      );
    }
  });

  test('HashUsecase - Exception: Empty Pin', () {
    const expectedPin = BasePin.empty();
    const usecase = HashUsecase();

    expect(
      () => usecase.encode('Lorem ipsum dolor sit amet', expectedPin),
      throwsA(
        isA<HashUsecaseEmptyPinError>(),
      ),
    );

    expect(
      () => usecase.tryDecode('Lorem ipsum dolor sit amet', expectedPin),
      throwsA(
        isA<HashUsecaseEmptyPinError>(),
      ),
    );
  });

  test('HashUsecase - Exception: Wrong pin length', () {
    final expectedPin = Pin(
      pin: '12345',
      pinSha512: const [],
      creationDate: DateTime.now(),
    );
    const usecase = HashUsecase();

    expect(
      () => usecase.encode('Lorem ipsum dolor sit amet', expectedPin),
      throwsA(
        isA<HashUsecaseWrongPinLengthError>(),
      ),
    );

    expect(
      () => usecase.tryDecode('Lorem ipsum dolor sit amet', expectedPin),
      throwsA(
        isA<HashUsecaseWrongPinLengthError>(),
      ),
    );
  });
}
