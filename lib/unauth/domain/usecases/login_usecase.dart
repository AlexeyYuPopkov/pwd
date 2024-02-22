import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';

final class LoginUsecase {
  final PinUsecase pinUsecase;
  final HashUsecase hashUsecase;

  const LoginUsecase({
    required this.pinUsecase,
    required this.hashUsecase,
  });

  Future<void> execute(String pin) {
    final pinString32 = hashUsecase.pinHash(pin);
    final pinList512 = hashUsecase.pinHash512(pin);

    return pinUsecase.setPin(
      Pin(
        pin: pinString32,
        pinSha512: pinList512,
      ),
    );
  }
}
