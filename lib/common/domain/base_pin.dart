abstract class BasePin {
  const BasePin();

  const factory BasePin.empty() = EmptyPin;

  factory BasePin.pin({required String pin}) = Pin;

  @override
  bool operator ==(Object other) => throw UnimplementedError();

  @override
  int get hashCode => throw UnimplementedError();
}

class Pin extends BasePin {
  final String pin;
  final DateTime creationDate = DateTime.now();

  Pin({required this.pin});

  @override
  bool operator ==(Object other) =>
      other is Pin && other.pin == pin && other.creationDate == creationDate;

  @override
  int get hashCode => Object.hashAll({pin, creationDate});
}

class EmptyPin extends BasePin {
  const EmptyPin();

  @override
  bool operator ==(Object other) => other is EmptyPin;

  @override
  int get hashCode => runtimeType.hashCode;
}
