import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/pin_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class PinUsecase {
  Stream<BasePin> get pinStream;

  Future<void> dropPin();

  BasePin getPin();

  Future<void> setPin(Pin pin);

  bool get isValidPin;
}

class PinUsecaseImpl implements PinUsecase {
  final PinRepository repository;
  final Duration validDuration;

  PinUsecaseImpl({required this.validDuration, required this.repository});

  late final _pinStream = BehaviorSubject<BasePin>.seeded(repository.getPin());

  late final _timerStream = Stream.periodic(validDuration).asBroadcastStream();

  @override
  Stream<BasePin> get pinStream => Rx.merge([
        _pinStream,
        _timerStream
            .map((event) => const BasePin.empty())
            .distinct((_, __) => repository.getPin() is EmptyPin),
      ])
          .doOnData(
            (e) => repository.setPin(e),
          )
          .asBroadcastStream();

  @override
  Future<void> dropPin() async {
    _pinStream.add(const BasePin.empty());
  }

  @override
  BasePin getPin() => repository.getPin();

  @override
  Future<void> setPin(Pin pin) async {
    _pinStream.add(pin);
  }

  @override
  bool get isValidPin {
    final pin = _pinStream.value;
    return pin is Pin &&
        pin.creationDate.add(validDuration).isAfter(DateTime.now());
  }
}