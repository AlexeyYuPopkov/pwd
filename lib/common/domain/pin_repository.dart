import 'base_pin.dart';

abstract class PinRepository {
  BasePin getPin();

  Future<void> setPin(Pin pin);

  Future<void> dropPin();

  Stream<BasePin> get pinStream;

  bool get isValidPin;
}
