import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intervalprogressbar/intervalprogressbar.dart';

class CircleProgressPainter extends IntervalProgressPainter {
  final double strokeWidth;

  CircleProgressPainter(
      int max,
      int progress,
      int intervalSize,
      Color highlightColor,
      Color defaultColor,
      Color intervalColor,
      Color intervalHighlightColor,
      double radius,
      bool reverse,
      double intervalPercent,
      this.strokeWidth)
      : super(
            max,
            progress,
            intervalSize,
            highlightColor,
            defaultColor,
            intervalColor,
            intervalHighlightColor,
            radius,
            reverse,
            intervalPercent);

  @override
  Size calBlockSize() {
    //Circle Progress will not call this
    return null;
  }

  @override
  void paintBlock(Canvas canvas, int blockIndex, Size blockSize) {
    //Circle Progress will not call this
  }

  final Path _path = Path();

  @override
  void paint(Canvas canvas, Size size) {
    painter
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = this.strokeWidth;

    Rect rect = Offset.zero & size;
    final radius = min(rect.height, rect.width);
    final r =
        Rect.fromCenter(center: rect.center, width: radius, height: radius);

    final incr = (360.0 - this.intervalDegrees * (this.max - 1)) / (this.max);
    final intervalRadians = degrees2radians(this.intervalDegrees);
    final swap = degrees2radians(incr);

    var start = 0.0;

    for (int i = 0; i < this.max; i++) {
      final highlight = highlightBlock(i);
      painter.color = highlight ? highlightColor : defaultColor;
      _path.addArc(r, start, swap);
      canvas.drawPath(_path, painter);
      _path.reset();
      start += swap;
      _path.addArc(r, start, intervalRadians);
      painter.color = intervalColor;
      canvas.drawPath(_path, painter);
      start += intervalRadians;
      _path.reset();
    }
  }

  double degrees2radians(double degrees) {
    return degrees * (pi / 180);
  }
}
