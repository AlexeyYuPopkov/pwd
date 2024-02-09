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

  bool get isValidPin;

  Pin createPin({
    required String pin,
    required List<int> pinSha512,
  });
}

final class PinUsecaseImpl implements PinUsecase {
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

  @override
  Pin createPin({
    required String pin,
    required List<int> pinSha512,
  }) {
    return Pin(
      pin: pin,
      pinSha512: pinSha512,
      creationDate: DateTime.now(),
    );
  }
}

final class PinUsecaseError extends AppError {
  const PinUsecaseError() : super(message: '');
}
