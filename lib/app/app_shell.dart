import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/design_system/tokens/app_radius.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';
import 'package:lifetrack/features/dashboard/dashboard_page.dart';
import 'package:lifetrack/features/vitals/vitals_page.dart';
import 'package:lifetrack/features/activity/activity_page.dart';
import 'package:lifetrack/features/nutrition/nutrition_page.dart';
import 'package:lifetrack/features/medical/ui/medical_screen.dart';
import 'package:lifetrack/features/profile/profile_page.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(), 
    const VitalsPage(),
    const ActivityPage(), 
    const NutritionPage(),
    const MedicalScreen(),
    const ProfilePage(), 
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          color: scheme.surface.withValues(alpha: 0.75),
          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.6)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            indicatorColor: scheme.primaryContainer.withValues(alpha: 0.8),
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.monitor_heart_outlined),
                selectedIcon: Icon(Icons.monitor_heart),
                label: 'Vitals',
              ),
              NavigationDestination(
                icon: Icon(Icons.directions_run_outlined),
                selectedIcon: Icon(Icons.directions_run),
                label: 'Activity',
              ),
              NavigationDestination(
                icon: Icon(Icons.restaurant_outlined),
                selectedIcon: Icon(Icons.restaurant),
                label: 'Nutrition',
              ),
              NavigationDestination(
                icon: Icon(Icons.medical_services_outlined),
                selectedIcon: Icon(Icons.medical_services),
                label: 'Medical',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
