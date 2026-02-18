import 'dart:math';
import 'package:flutter/material.dart';

class BreathingGradient extends StatelessWidget {
  final double t;

  const BreathingGradient(this.t, {super.key});

  @override
  Widget build(BuildContext context) {
    final double scale = 0.98 + (sin(t * 2 * pi) * 0.02);

    return Transform.scale(
      scale: scale,
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: <Color>[
              Color(0x2200BCD4),
              Colors.transparent,
            ],
            radius: 0.8,
          ),
        ),
      ),
    );
  }
}
