import 'package:flutter/material.dart';

class AppPageLayout extends StatelessWidget {
  final Widget child;
  final Widget? floatingAction;

  const AppPageLayout({
    super.key,
    required this.child,
    this.floatingAction,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false, // Bottom nav usually handles this, or we handle it in nav bar
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }
}
