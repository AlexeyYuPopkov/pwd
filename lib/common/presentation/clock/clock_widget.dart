import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:pwd/common/domain/time_formatter/time_formatter.dart';

import '../../domain/model/clock_model.dart';

final class ClockWidget extends StatelessWidget {
  final Color foregroundColor;
  final Color backgroundColor;

  final ClockModel parameters;
  final TimeFormatter formatter;
  final Stream<DateTime> timerStream;
  final VoidCallback? onLongTap;

  const ClockWidget({
    super.key,
    this.foregroundColor = Colors.black87,
    this.backgroundColor = Colors.black54,
    required this.parameters,
    required this.formatter,
    required this.timerStream,
    required this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClockBackgroundWidget(color: backgroundColor),
        RepaintBoundary(
          child: StreamBuilder<DateTime>(
            initialData: DateTime.now(),
            stream: timerStream.map(
              (e) => formatter.dateTimeInTimezone(
                date: e,
                timeZoneOffset: parameters.timeZoneOffset,
              ),
            ),
            builder: (context, snapshot) => ClockForegroundWidget(
              date: snapshot.data ?? DateTime.now(),
              color: foregroundColor,
              onLongTap: onLongTap,
            ),
          ),
        ),
      ],
    );
  }
}

class ClockBackgroundWidget extends LeafRenderObjectWidget {
  final Color color;
  const ClockBackgroundWidget({super.key, required this.color});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      ClockBackgroundRenderBox(color: color);
}

class ClockForegroundWidget extends LeafRenderObjectWidget {
  final Color color;
  final DateTime date;
  final VoidCallback? onLongTap;

  const ClockForegroundWidget({
    super.key,
    required this.color,
    required this.date,
    required this.onLongTap,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      ClockForegroundRenderBox(color: color, onLongTap: onLongTap);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant ClockForegroundRenderBox renderObject,
  ) =>
      renderObject
        ..date = date
        ..color = color
        ..onLongTap = onLongTap;
}

class ClockBackgroundRenderBox extends RenderBox {
  final Color color;

  ClockBackgroundRenderBox({
    required this.color,
  });

  DateTime _date = DateTime.now();

  DateTime get date => _date;
  set date(DateTime newValue) {
    if (newValue != _date) {
      _date = newValue;
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.constrain(
        Size(
          constraints.maxWidth,
          constraints.maxWidth,
        ),
      );

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    canvas.save();

    canvas.translate(offset.dx, offset.dy);

    _paintClock(canvas);

    canvas.restore();
  }

  void _paintClock(Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final centerX = (size.width ~/ 2).toDouble();
    final centerY = (size.height ~/ 2).toDouble();
    final radius = math.min(centerX, centerY);

    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      paint,
    );

    const hourPerDay = 12;
    const step = 2 * math.pi / hourPerDay;

    var angle = 0.0, dx = 0.0, dy = 0.0;
    var markX = 0.0, markY = 0.0;
    var sin = 0.0, mark = 0.0;

    const markLength = 3.0;
    const markBigLength = 6.0;

    final r2 = radius * radius;
    final diameter = radius + radius;

    for (int i = 0; i < hourPerDay; i++) {
      angle = i * step;

      sin = math.sin(angle);

      dy = radius * sin;
      dx = radius - math.sqrt(r2 - dy * dy);

      if (i > 3 && i < 9) {
        dx = diameter - dx;
      }

      mark = i % 3 == 0 ? markBigLength : markLength;

      markX = mark * math.cos(angle);
      markY = mark * sin;

      dy = centerY - dy;

      canvas.drawLine(
        Offset(dx, dy),
        Offset(dx + markX, dy + markY),
        paint,
      );
    }
  }
}

final class ClockForegroundRenderBox extends RenderBox {
  Color _color;

  VoidCallback? onLongTap;

  late final longPress = LongPressGestureRecognizer()
    ..onLongPressEnd = (_) => onLongTap?.call();

  ClockForegroundRenderBox({
    required Color color,
    required this.onLongTap,
  }) : _color = color;

  DateTime _date = DateTime.now();

  DateTime get date => _date;
  set date(DateTime newValue) {
    if (newValue != _date) {
      _date = newValue;
      markNeedsPaint();
    }
  }

  Color get color => _color;
  set color(Color newValue) {
    if (newValue != _color) {
      _color = newValue;
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.constrain(
        Size(
          constraints.maxWidth,
          constraints.maxWidth,
        ),
      );

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    canvas.save();

    canvas.translate(offset.dx, offset.dy);

    _paintTime(canvas);

    canvas.restore();
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent) {
      if (onLongTap != null) {
        longPress.addPointer(event);
      }
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;

  void _paintTime(Canvas canvas) {
    const doublePi = 2 * math.pi;
    const doublePi_4 = doublePi / 4;
    const secondsPerMinute = 60;
    const minutePerHour = 60;
    const secondsPerHour = minutePerHour * secondsPerMinute;
    const hourPerDay = 12;

    const minuresArrowRatio = 0.8;
    const hoursArrowRatio = 0.7;

    final paintSeconds = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    var angle = doublePi * date.second / secondsPerMinute - doublePi_4;

    final centerX = (size.width ~/ 2).toDouble();
    final centerY = (size.height ~/ 2).toDouble();
    var radius = math.min(centerX, centerY);
    var arrow = radius;

    var dX = radius * math.cos(angle);
    var dY = radius * math.sin(angle);

    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(centerX + dX, centerY + dY),
      paintSeconds,
    );

    final paintMinutes = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    angle = doublePi *
            (date.minute + date.second / secondsPerMinute) /
            minutePerHour -
        doublePi_4;

    arrow = minuresArrowRatio * radius;
    dX = arrow * math.cos(angle);
    dY = arrow * math.sin(angle);

    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(centerX + dX, centerY + dY),
      paintMinutes,
    );

    final paintHours = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    angle = doublePi *
            (date.hour +
                date.minute / minutePerHour +
                date.second / secondsPerHour) /
            hourPerDay -
        doublePi_4;
    arrow = hoursArrowRatio * radius;

    dX = arrow * math.cos(angle);
    dY = arrow * math.sin(angle);

    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(centerX + dX, centerY + dY),
      paintHours,
    );
  }
}
