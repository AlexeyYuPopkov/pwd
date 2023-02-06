import 'package:intl/intl.dart';

abstract class TimeFormatter {
  String time(DateTime date);

  String timeInTimezone({
    required DateTime date,
    required Duration timezoneOffset,
  });

  DateTime dateTimeInTimezone({
    required DateTime date,
    required Duration timezoneOffset,
  });
}

class TimeFormatterImpl implements TimeFormatter {
  TimeFormatterImpl();

  late final timeFormatter = DateFormat('HH:mm');

  @override
  String time(DateTime date) => timeFormatter.format(date);

  @override
  String timeInTimezone({
    required DateTime date,
    required Duration timezoneOffset,
  }) =>
      time(dateTimeInTimezone(date: date, timezoneOffset: timezoneOffset));

  @override
  DateTime dateTimeInTimezone({
    required DateTime date,
    required Duration timezoneOffset,
  }) {
    final utc = date.subtract(date.timeZoneOffset);
    final result = utc.add(timezoneOffset);
    return result;
  }
}
