import 'base_pin.dart';

abstract class PinRepository {
  // void dropPin();

  BasePin getPin();

  void setPin(BasePin pin);
}
