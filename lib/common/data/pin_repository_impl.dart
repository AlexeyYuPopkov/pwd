import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/pin_repository.dart';

class PinRepositoryImpl implements PinRepository {
  late var _pin = const BasePin.empty();

  @override
  void dropPin() async => _pin = const BasePin.empty();

  @override
  BasePin getPin() => _pin;

  @override
  void setPin(BasePin pin) => _pin = pin;
}
