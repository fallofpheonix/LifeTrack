import 'package:flutter/material.dart';
import '../../data/models/health_snapshot.dart';
import '../../core/utils/animated_fade_slide.dart';

import '../../data/models/intelligence/insight.dart';
import '../../data/models/clinical/recovery_data_point.dart'; // Add this
import '../../data/models/content/news_item.dart'; // Add this
import 'widgets/insights_section.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.snapshot,
    required this.insights,
    this.recoveryData = const [], // Optional default for now to avoid break if parent not updated immediately
    this.news = const [], 
    required this.onAddWater,
    required this.onRemoveWater,
    required this.onLogActivity,
    required this.onAddSleep,
  });

  final HealthSnapshot snapshot;
  final List<Insight> insights;
  final List<RecoveryDataPoint> recoveryData;
  final List<NewsItem> news;
  final VoidCallback onAddWater;
  final VoidCallback onRemoveWater;
  final VoidCallback onLogActivity;
  final VoidCallback onAddSleep;

  @override
  Widget build(BuildContext context) {
    final double hydrationProgress = snapshot.waterGlasses / snapshot.waterGoal;
    final double safeHydrationProgress = hydrationProgress.clamp(0, 1).toDouble();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        AnimatedFadeSlide(
          delay: const Duration(milliseconds: 80),
          child: _HeroCard(snapshot: snapshot),
        ),
        AnimatedFadeSlide(
          delay: const Duration(milliseconds: 100),
          child: InsightsSection(insights: insights),
        ),
        const SizedBox(height: 16),
        AnimatedFadeSlide(
          delay: const Duration(milliseconds: 120),
          child: Text('Daily Highlights', style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            AnimatedFadeSlide(
              delay: const Duration(milliseconds: 160),
              child: MetricCard(
                icon: Icons.directions_walk,
                title: 'Steps',
                value: '${snapshot.steps}/${snapshot.stepsGoal}',
                subtitle: '${(snapshot.steps / snapshot.stepsGoal * 100).round()}% goal',
              ),
            ),
            AnimatedFadeSlide(
              delay: const Duration(milliseconds: 210),
              child: MetricCard(
                icon: Icons.bedtime,
                title: 'Sleep',
                value: '${snapshot.sleepHours.toStringAsFixed(1)} h',
                subtitle: 'Target 8.0 h',
                onTap: onAddSleep,
              ),
            ),
            AnimatedFadeSlide(
              delay: const Duration(milliseconds: 260),
              child: MetricCard(
                icon: Icons.local_fire_department,
                title: 'Calories',
                value: '${snapshot.calories}',
                subtitle: 'Goal ${snapshot.caloriesGoal}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AnimatedFadeSlide(
          delay: const Duration(milliseconds: 300),
          child: Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFD9F2EA),
                child: Icon(Icons.water_drop, color: Color(0xFF1D8A6F)),
              ),
              title: Text('Hydration: ${snapshot.waterGlasses}/${snapshot.waterGoal} glasses'),
              subtitle: const Text('Keep water intake consistent across the day.'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: onRemoveWater,
                    tooltip: 'Remove',
                  ),
                  IconButton(
                     icon: const Icon(Icons.add),
                     onPressed: onAddWater,
                     tooltip: 'Add',
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedFadeSlide(
          delay: const Duration(milliseconds: 340),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: safeHydrationProgress),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (BuildContext context, double value, Widget? child) {
                return LinearProgressIndicator(
                  minHeight: 8,
                  value: value,
                  backgroundColor: const Color(0xFFD9E7E3),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        AnimatedFadeSlide(
          delay: const Duration(milliseconds: 380),
          child: Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  onPressed: onAddWater,
                  icon: const Icon(Icons.water_drop),
                  label: const Text('Add Water'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRemoveWater,
                  icon: const Icon(Icons.remove),
                  label: const Text('Remove Water'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onLogActivity,
                  icon: const Icon(Icons.fitness_center),
                  label: const Text('Log Activity'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9F2EA), // Corrected to use light color instead of transparent/dark
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF1D8A6F)),
              ),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 2),
              Text(subtitle),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final HealthSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final int stepsLeft = (snapshot.stepsGoal - snapshot.steps).clamp(0, snapshot.stepsGoal);
    final double progress = (snapshot.steps / snapshot.stepsGoal).clamp(0, 1).toDouble();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF1F8B70), Color(0xFF2AA783)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Welcome back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You are $stepsLeft steps away from your daily goal.',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: <Widget>[
              _HeroPill(
                icon: Icons.directions_walk,
                label: '${snapshot.steps} steps',
              ),
              _HeroPill(
                icon: Icons.water_drop,
                label: '${snapshot.waterGlasses}/${snapshot.waterGoal} glasses',
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeOutCubic,
            builder: (BuildContext context, double value, Widget? child) {
              return LinearProgressIndicator(
                minHeight: 8,
                borderRadius: BorderRadius.circular(100),
                value: value,
                backgroundColor: const Color(0x4DFFFFFF),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x40FFFFFF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
