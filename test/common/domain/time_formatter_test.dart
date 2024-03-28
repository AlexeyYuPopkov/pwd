import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';

void main() {
  group('TimeFormatterTest', () {
    late final TimeFormatter timeFormatter = TimeFormatterImpl();

    test('formattedTimeZoneOffsetOffset', () {
      expect(
        timeFormatter.formattedTimeZoneOffsetOffset(
          offset: const Duration(hours: 1),
        ),
        '+1',
      );
      expect(
        timeFormatter.formattedTimeZoneOffsetOffset(
          offset: const Duration(hours: 2),
        ),
        '+2',
      );
      expect(
        timeFormatter.formattedTimeZoneOffsetOffset(
          offset: const Duration(hours: -1),
        ),
        '-1',
      );
      expect(
        timeFormatter.formattedTimeZoneOffsetOffset(
          offset: const Duration(hours: -2),
        ),
        '-2',
      );
      expect(
        timeFormatter.formattedTimeZoneOffsetOffset(
          offset: const Duration(minutes: 30),
        ),
        '+0:30',
      );
      expect(
        timeFormatter.formattedTimeZoneOffsetOffset(
          offset: const Duration(hours: 1, minutes: 30),
        ),
        '+1:30',
      );
      expect(
        timeFormatter.formattedTimeZoneOffsetOffset(
          offset: const Duration(hours: 2, minutes: 15),
        ),
        '+2:15',
      );
      expect(
        timeFormatter.formattedTimeZoneOffsetOffset(
          offset: const Duration(minutes: -30),
        ),
        '-0:30',
      );
      expect(
        timeFormatter.formattedTimeZoneOffsetOffset(
          offset: const Duration(hours: -1, minutes: -30),
        ),
        '-1:30',
      );
      expect(
        timeFormatter.formattedTimeZoneOffsetOffset(
          offset: const Duration(hours: -2, minutes: -15),
        ),
        '-2:15',
      );
    });

    test('formatter - HH:mm', () {
      expect(
        timeFormatter.time(DateTime(2020, 1, 1, 13, 7)),
        '13:07',
      );
      expect(
        timeFormatter.time(DateTime(2020, 3, 3, 8, 21)),
        '08:21',
      );
    });

    test('timeInTimezone', () {
      expect(
        timeFormatter.timeInTimezone(
          date: DateTime(2020, 1, 1, 13, 7).toLocal(),
          timezoneOffset: const Duration(hours: 2),
        ),
        '13:07',
      );
      expect(
        timeFormatter.timeInTimezone(
          date: DateTime(2020, 1, 1, 13, 7).toLocal(),
          timezoneOffset: const Duration(hours: 3),
        ),
        '14:07',
      );
      expect(
        timeFormatter.timeInTimezone(
          date: DateTime(2020, 3, 3, 13, 7).toLocal(),
          timezoneOffset: const Duration(hours: -2),
        ),
        '09:07',
      );
      expect(
        timeFormatter.timeInTimezone(
          date: DateTime(2020, 3, 3, 13, 7).toLocal(),
          timezoneOffset: const Duration(hours: -3),
        ),
        '08:07',
      );
    });
  });
}
