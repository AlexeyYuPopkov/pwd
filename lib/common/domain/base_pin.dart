sealed class BasePin {
  const BasePin();

  const factory BasePin.empty() = EmptyPin;

  factory BasePin.pin({required String pin, required List<int> pinSha512}) =
      Pin;

  @override
  bool operator ==(Object other) => throw UnimplementedError();

  @override
  int get hashCode => throw UnimplementedError();
}

final class Pin extends BasePin {
  final String pin;
  final List<int> pinSha512;
  final DateTime creationDate = DateTime.now();

  Pin({
    required this.pin,
    required this.pinSha512,
  });

  @override
  bool operator ==(Object other) =>
      other is Pin &&
      other.pin == pin &&
      other.pinSha512 == pinSha512 &&
      other.creationDate == creationDate;

  @override
  int get hashCode => Object.hashAll({pin, creationDate});
}

final class EmptyPin extends BasePin {
  const EmptyPin();

  @override
  bool operator ==(Object other) => other is EmptyPin;

  @override
  int get hashCode => runtimeType.hashCode;
}
