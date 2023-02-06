class ClockModel {
  final String label;
  final Duration timezoneOffset;

  const ClockModel({
    required this.label,
    required this.timezoneOffset,
  });

  @override
  bool operator ==(Object other) =>
      other is ClockModel &&
      other.label == label &&
      other.timezoneOffset == timezoneOffset;

  @override
  int get hashCode => Object.hashAll({label, timezoneOffset});
}
