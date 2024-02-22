import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/common/domain/pin_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class PinUsecase {
  Stream<BasePin> get pinStream;

  Future<void> dropPin();

  BasePin getPin();

  Pin getPinOrThrow();

  Future<void> setPin(Pin pin);
}

final class PinUsecaseImpl implements PinUsecase {
  final PinRepository repository;
  final Duration validDuration;

  PinUsecaseImpl({required this.validDuration, required this.repository});

  late final _pinStream = BehaviorSubject<BasePin>.seeded(repository.getPin());

  late final _timerStream = Stream.periodic(validDuration).asBroadcastStream();

  static var i = 0;
  @override
  Stream<BasePin> get pinStream => Rx.merge(
        [
          _pinStream,
          _timerStream
              .map(
                (_) => const BasePin.empty(),
              )
              .distinct(),
        ],
      )
          .distinct()
          .doOnData(
            (e) => repository.setPin(e),
          )
          .asBroadcastStream();

  @override
  Future<void> dropPin() async {
    _pinStream.add(const BasePin.empty());
  }

  @override
  BasePin getPin() => _pinStream.value;

  @override
  Future<void> setPin(Pin pin) async {
    _pinStream.add(pin);
  }

  @override
  Pin getPinOrThrow() {
    final pin = _pinStream.value;
    switch (pin) {
      case Pin():
        return pin;
      case EmptyPin():
        throw const PinUsecaseError();
    }
  }
}

final class PinUsecaseError extends AppError {
  const PinUsecaseError() : super(message: '');
}
