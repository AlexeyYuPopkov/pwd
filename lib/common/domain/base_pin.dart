abstract class BasePin {
  const BasePin();

  bool get hasPin {
    final self = this;
    return self is Pin && self.pin.isNotEmpty;
  }

  const factory BasePin.empty() = EmptyPin;

  const factory BasePin.pin({
    required String pin,
  }) = Pin;
}

class Pin extends BasePin {
  final String pin;
  const Pin({required this.pin});
}

class EmptyPin extends BasePin {
  const EmptyPin();
}
