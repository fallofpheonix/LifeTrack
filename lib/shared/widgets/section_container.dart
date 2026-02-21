import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lifetrack/core/theme/app_colors_extension.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(_padding),
    this.blurSigma = _blurSigma,
  });

  static const double _radius = 24;
  static const double _padding = 16;
  static const double _blurSigma = 10;

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_radius),
            color: c.surfaceElevated,
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
