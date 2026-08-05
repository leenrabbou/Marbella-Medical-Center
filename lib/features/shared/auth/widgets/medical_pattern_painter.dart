import 'dart:math';
import 'package:flutter/material.dart';

class MedicalPatternPainter extends CustomPainter {
  final Color color;

  MedicalPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha((0.1 * 255).toInt())
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const spacing = 180.0;
    final crossSize = 12.0;

    final random = Random(100);

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        final cx = x + random.nextDouble() * 40 - 20;
        final cy = y + random.nextDouble() * 40 - 20;

        canvas.drawLine(
          Offset(cx - crossSize / 2, cy),
          Offset(cx + crossSize / 2, cy),
          paint,
        );
        canvas.drawLine(
          Offset(cx, cy - crossSize / 2),
          Offset(cx, cy + crossSize / 2),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
