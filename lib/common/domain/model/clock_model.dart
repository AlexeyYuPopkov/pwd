import 'package:uuid/uuid.dart';

final class ClockModel {
  final String id;
  final String label;
  final Duration timeZoneOffset;

  factory ClockModel({
    required String label,
    required Duration timezoneOffset,
  }) =>
      ClockModel._(
        id: const Uuid().v1(),
        label: label,
        timeZoneOffset: timezoneOffset,
      );

  factory ClockModel.newClock() => ClockModel._(
        id: const Uuid().v1(),
        label: '',
        timeZoneOffset: DateTime.now().timeZoneOffset,
      );

  factory ClockModel.fromStorage({
    required String id,
    required String label,
    required Duration timezoneOffset,
  }) =>
      ClockModel._(
        id: id,
        label: label,
        timeZoneOffset: timezoneOffset,
      );

  const ClockModel._({
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
    return ClockModel._(
      id: id,
      label: label ?? this.label,
      timeZoneOffset: timeZoneOffset ?? this.timeZoneOffset,
    );
  }
}
