import 'package:flutter/material.dart';
import 'package:lifetrack/core/theme/app_colors_extension.dart';
import 'package:lifetrack/shared/widgets/section_container.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.title,
    required this.primaryValue,
    required this.secondaryLabel,
    super.key,
    this.visualization,
  });

  static const double _titleSize = 13;
  static const double _valueSize = 30;
  static const double _spacingS = 8;
  static const double _spacingM = 12;
  static const FontWeight _titleWeight = FontWeight.w500;
  static const FontWeight _valueWeight = FontWeight.w800;

  final String title;
  final String primaryValue;
  final String secondaryLabel;
  final Widget? visualization;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: c.textSecondary,
              fontSize: _titleSize,
              fontWeight: _titleWeight,
            ),
          ),
          const SizedBox(height: _spacingS),
          Text(
            primaryValue,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: _valueSize,
              fontWeight: _valueWeight,
            ),
          ),
          const SizedBox(height: _spacingS),
          Text(
            secondaryLabel,
            style: TextStyle(color: c.textSecondary),
          ),
          if (visualization != null) ...<Widget>[
            const SizedBox(height: _spacingM),
            visualization!,
          ],
        ],
      ),
    );
  }
}
