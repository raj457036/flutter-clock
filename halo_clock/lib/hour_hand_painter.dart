import 'dart:math';
import 'package:flutter/material.dart';

class HourHandPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double width;
  int hour;
  int totalHour;
  Color color;
  HourHandPainter({
    this.lineColor,
    this.width,
    this.hour,
    this.totalHour,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final percent = hour / totalHour;

    double arcAngle = 2 * pi * percent;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 12;

    final textStyle = TextStyle(
      color: color,
      fontSize: totalHour == 12 ? width * 0.96 : width * 0.7,
      fontWeight: FontWeight.bold,
    );

    final angelOffset = totalHour == 24 ? 1.309 : pi / 3;
    for (int i = 0; i < totalHour; i++) {
      final double angle = ((pi / (totalHour / 2)) * i) - angelOffset;

      final y = radius * sin(angle);
      final x = radius * cos(angle);
      final textSpan = TextSpan(
        text: '${i + 1}',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      final offset = Offset(x, y) + center - Offset(width / 2.4, width / 1.6);
      textPainter.paint(canvas, offset);
    }

    Paint arc = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -1.35,
        arcAngle - 0.4, false, arc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
