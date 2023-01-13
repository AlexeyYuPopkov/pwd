import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/pin_repository.dart';
import 'package:rxdart/rxdart.dart';

class PinDataSource implements PinRepository {
  final _pinStream = BehaviorSubject<BasePin>.seeded(BasePin.empty());

  @override
  Future<void> dropPin() async {
    _pinStream.add(BasePin.empty());
  }

  @override
  BasePin getPin() => _pinStream.value;

  @override
  Stream<BasePin> get pinStream => _pinStream;

  @override
  Future<void> setPin(Pin pin) async {
    _pinStream.add(pin);
  }
}
