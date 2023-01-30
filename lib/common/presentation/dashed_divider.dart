import 'dart:math';

import 'package:flutter/material.dart';

class DashedDivider extends LeafRenderObjectWidget {
  static const double defaultHeight = 1.0;
  static const double defaultThickness = 1.0;
  static const double defaultIndent = 0.0;
  static const double defaultEndIndent = 0.0;
  static const double defaultDash = 10.0;
  static const double defaultSpace = 10.0;

  static const defaultColor = Colors.grey;
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;
  final double dash;
  final double disaredSpace;
  final Color? color;

  const DashedDivider({
    super.key,
    this.height = defaultHeight,
    this.thickness = defaultThickness,
    this.indent = defaultIndent,
    this.endIndent = defaultEndIndent,
    this.dash = defaultDash,
    this.disaredSpace = defaultSpace,
    this.color,
  });

  @override
  RenderObject createRenderObject(BuildContext context) => TestRenderObject(
        height: height,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        dash: dash,
        disaredSpace: disaredSpace,
        color: color ?? Theme.of(context).dividerColor,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    covariant TestRenderObject renderObject,
  ) {
    renderObject
      ..height = height
      ..thickness = thickness
      ..indent = indent
      ..endIndent = endIndent
      ..dash = dash
      ..disaredSpace = disaredSpace
      ..color = color ?? Theme.of(context).dividerColor;
  }
}

class TestRenderObject extends RenderBox {
  double _height = DashedDivider.defaultHeight;
  double _thickness = DashedDivider.defaultThickness;
  double _indent = DashedDivider.defaultIndent;
  double _endIndent = DashedDivider.defaultEndIndent;
  double _dash = DashedDivider.defaultDash;
  double _disaredSpace = DashedDivider.defaultSpace;
  Color _color;

  Color get color => _color;
  set color(Color color) {
    if (color != _color) {
      _color = color;
      markNeedsPaint();
    }
  }

  double get indent => _indent;
  set indent(double indent) {
    if (indent != _indent) {
      _indent = indent;
      markNeedsLayout();
    }
  }

  double get endIndent => _endIndent;
  set endIndent(double endIndent) {
    if (endIndent != _endIndent) {
      _endIndent = endIndent;
      markNeedsLayout();
    }
  }

  double get disaredSpace => _disaredSpace;
  set disaredSpace(double disaredSpace) {
    if (disaredSpace != _disaredSpace) {
      _disaredSpace = disaredSpace;
      markNeedsLayout();
    }
  }

  double get dash => _dash;
  set dash(double dash) {
    if (dash != _dash) {
      _dash = dash;
      markNeedsLayout();
    }
  }

  double get height => _height;
  set height(double height) {
    if (height != _height) {
      _height = height;
      markNeedsLayout();
    }
  }

  double get thickness => _thickness;
  set thickness(double thickness) {
    if (thickness != _thickness) {
      _thickness = thickness;
      markNeedsLayout();
    }
  }

  TestRenderObject({
    required double height,
    required double thickness,
    required double indent,
    required double endIndent,
    required double dash,
    required double disaredSpace,
    required Color color,
  })  : _height = height,
        _indent = indent,
        _endIndent = endIndent,
        _disaredSpace = disaredSpace,
        _dash = dash,
        _thickness = thickness,
        _color = color;

  @override
  void performLayout() {
    size = constraints.constrain(
      Size(
        _sizeFromWidth(constraints.maxWidth),
        height,
      ),
    );
  }

  double _sizeFromWidth(double width) => max(0.0, width - indent - endIndent);

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    canvas.save();
    canvas.translate(offset.dx, offset.dy + height ~/ 2);
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickness;

    final width = _sizeFromWidth(size.width);

    final desiredPeriod = dash + disaredSpace;

    final count = width ~/ desiredPeriod;

    final extraSpace = (width - desiredPeriod * count + dash) /
        max(
          1.0,
          count - 1,
        );

    final step = desiredPeriod + extraSpace;

    double startDash = offset.dx;

    for (int i = 0; i < count; i++) {
      startDash = i * step;

      canvas.drawLine(
        Offset(startDash, 0.0),
        Offset(startDash + dash, 0.0),
        paint,
      );
    }

    canvas.restore();
  }
}
