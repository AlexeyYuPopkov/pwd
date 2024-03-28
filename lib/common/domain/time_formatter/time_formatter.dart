import 'package:intl/intl.dart';

abstract class TimeFormatter {
  String time(DateTime date);

  String timeInTimezone({
    required DateTime date,
    required Duration timezoneOffset,
  });

  DateTime dateTimeInTimezone({
    required DateTime date,
    required Duration timeZoneOffset,
  });

  String formattedTimeZoneOffsetOffset({
    required Duration offset,
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
      time(
        dateTimeInTimezone(date: date, timeZoneOffset: timezoneOffset),
      );

  @override
  DateTime dateTimeInTimezone({
    required DateTime date,
    required Duration timeZoneOffset,
  }) {
    if (timeZoneOffset == Duration.zero) {
      return date;
    } else {
      final utc = date.subtract(date.timeZoneOffset);
      final result = utc.add(timeZoneOffset);
      return result;
    }
  }

  @override
  String formattedTimeZoneOffsetOffset({
    required Duration offset,
  }) {
    final absDuration = offset.abs();
    final minutes = absDuration.inMinutes.remainder(60);
    final result =
        '${absDuration.inHours}${minutes == 0 ? '' : ':${_twoDigits(minutes)}'}';

    return offset.inMilliseconds > 0 ? '+$result' : '-$result';
  }
}

String _twoDigits(int n) => n.toString().padLeft(2, '0');
