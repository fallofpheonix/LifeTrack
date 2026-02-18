import 'package:flutter/material.dart';
import '../../settings/ui_preferences.dart';
import 'ecg_painter.dart';

class AnimatedHealthBackground extends StatefulWidget {
  const AnimatedHealthBackground({super.key});

  @override
  State<AnimatedHealthBackground> createState() => _AnimatedHealthBackgroundState();
}

class _AnimatedHealthBackgroundState extends State<AnimatedHealthBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(); // infinite loop
  }

  @override
  Widget build(BuildContext context) {
    if (UiPreferences.reduceMotion) {
      return const SizedBox.shrink(); // No animation if reduced motion is enabled
    }

    return IgnorePointer(
      // UI interactions pass through
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return CustomPaint(
              painter: EcgPainter(_controller.value),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
