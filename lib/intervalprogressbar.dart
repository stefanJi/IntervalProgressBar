library intervalprogressbar;

import 'dart:ui';
import 'package:flutter/widgets.dart';

class IntervalProgressBar extends StatelessWidget {
  final IntervalProgressDirection direction;
  final int max;
  final int progress;
  final int intervalSize;
  final Size size;
  final Color highlightColor;
  final Color defaultColor;
  final Color intervalColor;
  final Color intervalHighlightColor;
  final double radius;
  final bool reverse;

  const IntervalProgressBar(
      {Key key,
      this.direction = IntervalProgressDirection.horizontal,
      @required this.max,
      @required this.progress,
      @required this.intervalSize,
      @required this.size,
      @required this.highlightColor,
      @required this.defaultColor,
      @required this.intervalColor,
      @required this.intervalHighlightColor,
      @required this.radius,
      this.reverse = false})
      : super(key: key);

  static const IntervalProgressBar demo = IntervalProgressBar(
      direction: IntervalProgressDirection.horizontal,
      max: 10,
      progress: 6,
      intervalSize: 2,
      size: Size(double.infinity, 6),
      highlightColor: Color.fromARGB(255, 117, 112, 255),
      defaultColor: Color.fromARGB(50, 117, 112, 255),
      intervalColor: TRANSPARENT,
      intervalHighlightColor: Color.fromARGB(180, 117, 112, 255),
      radius: 3,
      reverse: false);

  static const TRANSPARENT = Color.fromARGB(0, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: direction == IntervalProgressDirection.horizontal
            ? HorizontalProgressPainter(
                max,
                progress,
                intervalSize,
                highlightColor,
                defaultColor,
                intervalColor,
                intervalHighlightColor,
                radius,
                reverse)
            : VerticalProgressPainter(
                max,
                progress,
                intervalSize,
                highlightColor,
                defaultColor,
                intervalColor,
                intervalHighlightColor,
                radius,
                reverse),
        size: size);
  }
}

enum IntervalProgressDirection { vertical, horizontal }

abstract class IntervalProgressPainter extends CustomPainter {
  final int max;
  final int progress;
  final int intervalSize;
  final Color highlightColor;
  final Color defaultColor;
  final Color intervalColor;
  final Color intervalHighlightColor;
  final double radius;
  final bool reverse;

  final Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;

  Rect bound;

  IntervalProgressPainter(
      this.max,
      this.progress,
      this.intervalSize,
      this.highlightColor,
      this.defaultColor,
      this.intervalColor,
      this.intervalHighlightColor,
      this.radius,
      this.reverse);

  @override
  @mustCallSuper
  void paint(Canvas canvas, Size size) {
    if (progress > max) {
      throw Exception("progress must <= max");
    }
    bound = Offset.zero & size;
    Size blockSize = calBlockSize();
    for (int i = 0; i < max; i++) {
      paintBlock(canvas, i, blockSize);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final old = oldDelegate as IntervalProgressPainter;
    return old.max != max ||
        old.progress != progress ||
        old.intervalSize != intervalSize ||
        old.intervalColor != intervalColor ||
        old.defaultColor != defaultColor ||
        old.highlightColor != highlightColor ||
        old.intervalHighlightColor != intervalHighlightColor ||
        old.radius != radius;
  }

  bool highlightBlock(int index) =>
      reverse ? index >= (max - progress) : index < progress;

  bool highlightInterval(int index) =>
      reverse ? index >= (max - progress - 1) : index < progress - 1;

  void paintBlock(Canvas canvas, int blockIndex, Size blockSize);

  Size calBlockSize();

  bool shouldDrawStartRadius(int index) => index == 0 && radius > 0;

  bool shouldDrawEndRadius(int index) => index == max - 1 && radius > 0;

  bool shouldDrawInterval(int index) =>
      index != max - 1 &&
      (intervalColor != IntervalProgressBar.TRANSPARENT ||
          intervalHighlightColor != IntervalProgressBar.TRANSPARENT);
}

class HorizontalProgressPainter extends IntervalProgressPainter {
  HorizontalProgressPainter(
      int max,
      int progress,
      int intervalWidth,
      Color highlightColor,
      Color defaultColor,
      Color intervalColor,
      Color intervalHighlightColor,
      double radius,
      bool reverse)
      : super(max, progress, intervalWidth, highlightColor, defaultColor,
            intervalColor, intervalHighlightColor, radius, reverse);

  @override
  Size calBlockSize() =>
      Size(((bound.width - intervalSize * (max - 1)) / max), bound.height);

  @override
  void paintBlock(Canvas canvas, int i, Size blockSize) {
    final blockWidth = blockSize.width;
    final highlight = highlightBlock(i);
    final dx = (blockWidth + intervalSize) * i;

    Rect rect = Rect.fromLTRB(0, 0, blockWidth, bound.height);
    _paint.color = highlight ? highlightColor : defaultColor;
    canvas.save();
    canvas.translate(dx, 0);
    if (shouldDrawStartRadius(i)) {
      rect = _drawLeftRound(canvas, rect);
    }

    if (shouldDrawEndRadius(i)) {
      rect = _drawRightRound(canvas, rect);
    }

    canvas.drawRect(rect, _paint);

    if (shouldDrawInterval(i)) {
      _paint.color =
          highlightInterval(i) ? intervalHighlightColor : intervalColor;
      canvas.drawRect(
          Rect.fromLTRB(
            blockWidth,
            0,
            blockWidth + intervalSize,
            bound.height,
          ),
          _paint);
    }
    canvas.restore();
  }

  Rect _drawLeftRound(Canvas canvas, Rect rect) {
    final clipRect =
        Rect.fromLTRB(rect.left + radius, rect.top, rect.right, rect.bottom);
    _drawRadius(canvas, rect, clipRect);
    return clipRect;
  }

  Rect _drawRightRound(Canvas canvas, Rect rect) {
    final clipRect =
        Rect.fromLTRB(rect.left, rect.top, rect.right - radius, rect.bottom);
    _drawRadius(canvas, rect, clipRect);
    return clipRect;
  }

  void _drawRadius(Canvas canvas, Rect rect, Rect clipRect) {
    final roundRect = RRect.fromLTRBR(
        rect.left, rect.top, rect.right, rect.bottom, Radius.circular(radius));
    final path = Path()..addRRect(roundRect);
    canvas.save();
    canvas.clipRect(clipRect, clipOp: ClipOp.difference);
    canvas.drawPath(path, _paint);
    canvas.restore();
  }
}

class VerticalProgressPainter extends IntervalProgressPainter {
  VerticalProgressPainter(
      int max,
      int progress,
      int intervalWidth,
      Color highlightColor,
      Color defaultColor,
      Color intervalColor,
      Color intervalHighlightColor,
      double radius,
      bool reverse)
      : super(max, progress, intervalWidth, highlightColor, defaultColor,
            intervalColor, intervalHighlightColor, radius, reverse);

  @override
  void paintBlock(Canvas canvas, int i, Size blockSize) {
    final blockHeight = blockSize.height;
    final dy = (blockHeight + intervalSize) * i;
    Rect rect = Rect.fromLTRB(0, 0, bound.width, blockHeight);

    canvas.save();
    canvas.translate(0, dy);
    _paint.color = highlightBlock(i) ? highlightColor : defaultColor;
    if (shouldDrawStartRadius(i)) {
      rect = _drawStartRadius(canvas, rect);
    }
    if (shouldDrawEndRadius(i)) {
      rect = _drawEndRadius(canvas, rect);
    }
    canvas.drawRect(rect, _paint);
    if (shouldDrawInterval(i)) {
      _paint.color =
          highlightInterval(i) ? intervalHighlightColor : intervalColor;
      final intervalRect = Rect.fromLTRB(
          0, blockHeight, bound.width, blockHeight + intervalSize);
      canvas.drawRect(intervalRect, _paint);
    }
    canvas.restore();
  }

  @override
  Size calBlockSize() =>
      Size(bound.width, (bound.height - intervalSize * (max - 1)) / max);

  Rect _drawStartRadius(Canvas canvas, Rect rect) {
    final clipRect =
        Rect.fromLTRB(rect.left, rect.top + radius, rect.right, rect.bottom);
    _drawRadius(canvas, rect, clipRect);
    return clipRect;
  }

  Rect _drawEndRadius(Canvas canvas, Rect rect) {
    final clipRect =
        Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom - radius);
    _drawRadius(canvas, rect, clipRect);
    return clipRect;
  }

  void _drawRadius(Canvas canvas, Rect rect, Rect clipRect) {
    final rRect = RRect.fromLTRBR(
        rect.left, rect.top, rect.right, rect.bottom, Radius.circular(radius));
    final p = Path()..addRRect(rRect);
    canvas.save();
    canvas.clipRect(clipRect, clipOp: ClipOp.difference);
    canvas.drawPath(p, _paint);
    canvas.restore();
  }
}
