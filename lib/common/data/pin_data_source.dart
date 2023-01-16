import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/pin_repository.dart';
import 'package:rxdart/rxdart.dart';

class PinDataSource implements PinRepository {
  static const validTill = Duration(hours: 4);
  final _pinStream = BehaviorSubject<BasePin>.seeded(const BasePin.empty());

  @override
  Future<void> dropPin() async {
    _pinStream.add(const BasePin.empty());
  }

  @override
  BasePin getPin() => _pinStream.value;

  @override
  Stream<BasePin> get pinStream => _pinStream.distinct(
        (one, other) => one == other,
      );

  @override
  Future<void> setPin(Pin pin) async {
    _pinStream.add(pin);
  }

  @override
  bool get isValidPin {
    final pin = _pinStream.value;
    return pin is Pin &&
        pin.creationDate.add(validTill).isAfter(DateTime.now());
  }
}
