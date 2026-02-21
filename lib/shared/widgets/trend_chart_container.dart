import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lifetrack/core/theme/app_colors_extension.dart';

class TrendChartContainer extends StatelessWidget {
  const TrendChartContainer({
    required this.child,
    super.key,
    this.height = _defaultHeight,
  });

  static const double _radius = 20;
  static const double _defaultHeight = 180;
  static const double _padding = 12;
  static const double _blurSigma = 8;

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              color: c.surfaceSubtle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(_padding),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
