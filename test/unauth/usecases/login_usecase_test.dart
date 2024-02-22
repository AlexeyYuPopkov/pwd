import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/unauth/domain/usecases/login_usecase.dart';

@GenerateNiceMocks(
  [
    MockSpec<PinUsecase>(),
    MockSpec<HashUsecase>(),
  ],
)
import 'login_usecase_test.mocks.dart';

void main() {
  group(
    'LoginUsecase',
    () {
      test(
        'Check methods call',
        () async {
          final pinUsecase = MockPinUsecase();
          final hashUsecase = MockHashUsecase();

          final usecase = LoginUsecase(
            pinUsecase: pinUsecase,
            hashUsecase: hashUsecase,
          );

          const pinStr = '';

          const dummyPin = Pin(
            pin: pinStr,
            pinSha512: [],
          );

          provideDummy(dummyPin);

          when(
            hashUsecase.pinHash(pinStr),
          ).thenReturn(dummyPin.pin);

          when(
            hashUsecase.pinHash512(pinStr),
          ).thenReturn(dummyPin.pinSha512);

          await usecase.execute(pinStr);

          verifyInOrder([
            hashUsecase.pinHash(pinStr),
            hashUsecase.pinHash512(pinStr),
            pinUsecase.setPin(dummyPin)
          ]);
        },
      );
    },
  );
}
