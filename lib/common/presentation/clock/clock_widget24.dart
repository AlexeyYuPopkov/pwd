import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:pwd/common/domain/time_formatter/time_formatter.dart';

import '../../domain/model/clock_model.dart';

class ClockWidget24 extends StatelessWidget {
  final ClockModel parameters;
  final TimeFormatter formatter;
  final Stream<DateTime> timerStream;

  const ClockWidget24({
    super.key,
    required this.formatter,
    required this.parameters,
    required this.timerStream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: DateTime.now(),
        stream: timerStream,
        builder: (context, snapshot) {
          final date = snapshot.data;

          if (date is DateTime) {
            return Text(
              formatter.timeInTimezone(
                date: date,
                timezoneOffset: parameters.timeZoneOffset,
              ),
              style: const TextStyle(
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
