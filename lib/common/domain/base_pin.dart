sealed class BasePin {
  const BasePin();

  const factory BasePin.empty() = EmptyPin;

  @override
  bool operator ==(Object other) => throw UnimplementedError();

  @override
  int get hashCode => throw UnimplementedError();
}

final class Pin extends BasePin {
  final String pin;
  final List<int> pinSha512;

  const Pin({
    required this.pin,
    required this.pinSha512,
  });

  @override
  bool operator ==(Object other) =>
      other is Pin && other.pin == pin && other.pinSha512 == pinSha512;

  @override
  int get hashCode => Object.hashAll({
        pin,
        pinSha512,
      });
}

final class EmptyPin extends BasePin {
  const EmptyPin();

  @override
  bool operator ==(Object other) {
    return other is EmptyPin;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}
