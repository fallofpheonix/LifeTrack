import 'package:flutter/material.dart';

class BaseCard extends StatefulWidget {
  const BaseCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  State<BaseCard> createState() => _BaseCardState();
}

class _BaseCardState extends State<BaseCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _scale = 0.992),
          onTapCancel: () => setState(() => _scale = 1.0),
          onTapUp: (_) => setState(() => _scale = 1.0),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(16),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
