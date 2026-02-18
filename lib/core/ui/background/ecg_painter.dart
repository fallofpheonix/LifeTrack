import 'dart:math';
import 'package:flutter/material.dart';

class EcgPainter extends CustomPainter {
  final double phase;

  EcgPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.15)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    final double width = size.width;
    final double height = size.height * 0.5;

    // Optimize: Reduce loop iterations using curves instead of pixel-by-pixel if performance issues arise
    // For now, step size 5 to reduce calculations
    for (double x = 0; x < width; x+=5) {
      final double normalized = (x / width + phase) % 1.0;
      final double y = height +
          sin(normalized * 2 * pi * 3) * 12; // soft ECG wave

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant EcgPainter oldDelegate) =>
      oldDelegate.phase != phase;
}
