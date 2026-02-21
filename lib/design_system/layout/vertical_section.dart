import 'package:flutter/material.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';

class VerticalSection extends StatelessWidget {
  const VerticalSection({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .expand((Widget child) => <Widget>[child, const SizedBox(height: AppSpacing.md)])
          .toList()
        ..removeLast(),
    );
  }
}
