import 'package:uuid/uuid.dart';

final class ClockModel {
  final String id;
  final String label;
  final Duration timeZoneOffset;

  factory ClockModel.newClock() => ClockModel(
        id: const Uuid().v1(),
        label: '',
        timeZoneOffset: DateTime.now().timeZoneOffset,
      );

  const ClockModel({
    required this.id,
    required this.label,
    required this.timeZoneOffset,
  });

  @override
  bool operator ==(Object other) =>
      other is ClockModel &&
      other.id == id &&
      other.label == label &&
      other.timeZoneOffset == timeZoneOffset;

  @override
  int get hashCode => Object.hashAll({id});

  ClockModel copyWith({
    String? label,
    Duration? timeZoneOffset,
  }) {
    return ClockModel(
      id: id,
      label: label ?? this.label,
      timeZoneOffset: timeZoneOffset ?? this.timeZoneOffset,
    );
  }
}
