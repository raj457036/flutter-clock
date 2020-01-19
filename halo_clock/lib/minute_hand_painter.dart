import 'dart:math';
import 'package:flutter/material.dart';

class MinuteHandPainter extends CustomPainter {
  Color lineColor;
  double width;
  int value;
  Color color;
  MinuteHandPainter({
    this.lineColor,
    this.width,
    this.value,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double angleOffset = value * 0.10472;

    double arcAngle = (2 * pi * 0.9);
    double startAngle = (-pi / 2) + angleOffset + 0.4;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 40;

    final textStyle = TextStyle(
      color: color,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

    final y = radius * sin(startAngle - 0.3);
    final x = radius * cos(startAngle - 0.3);
    final textSpan = TextSpan(
      text: '$value',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset =
        Offset(x, y) + center - Offset(width / 2 + 3.5, width / 2 + 3.5);
    textPainter.paint(canvas, offset);

    Paint arc = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 2),
        startAngle, arcAngle, false, arc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
