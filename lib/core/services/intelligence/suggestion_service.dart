import 'package:lifetrack/data/models/health_snapshot.dart';
import 'package:lifetrack/data/models/user_profile.dart';
import 'package:lifetrack/data/models/intelligence/insight.dart';

class SuggestionService {
  /// Generates rule-based insights based on current snapshot and profile.
  List<Insight> generateInsights(
    HealthSnapshot snapshot, 
    UserProfile profile, {
    List<dynamic>? sleepEntries, // Dynamic to avoid circular import or just ignore for now if not used
    double? consistencyScore,
  }) {
    final List<Insight> insights = [];
    final now = DateTime.now();

    // 1. Hydration Logic
    // Goal: 8 glasses.
    // By 2 PM (14:00), should have at least 4.
    if (now.hour >= 14 && snapshot.waterGlasses < 4) {
      insights.add(Insight(
        id: 'sugg_hydro_afternoon',
        title: 'Hydration Lag',
        message: "It's past 2 PM and you're behind on water. Time for a glass!",
        type: InsightType.warning,
        date: now,
        actionLabel: 'Log Water',
      ));
    } else if (snapshot.waterGlasses >= 8) {
       insights.add(Insight(
        id: 'sugg_hydro_goal',
        title: 'Hydration Goal Met',
        message: "Great job hitting your water goal today!",
        type: InsightType.success,
        date: now,
      ));
    }

    // 2. Activity Logic
    // Simple check against step goal (default 10k if not set in profile? Snap has steps)
    // Assuming 10k is standard if not in profile (Profile doesn't have step goal usually, store might)
    const int stepGoal = 10000; 
    if (now.hour >= 18 && snapshot.steps < stepGoal / 2) {
       insights.add(Insight(
        id: 'sugg_move_evening',
        title: 'Time to Move?',
        message: "You've been sedentary today. How about a short evening walk?",
        type: InsightType.info,
        date: now,
        actionLabel: 'Start Activity',
      ));
    }

    // 3. Sleep Logic
    // If sleep data exists in snapshot (sleepHours)
    if (snapshot.sleepHours > 0 && snapshot.sleepHours < 6) {
       insights.add(Insight(
        id: 'sugg_sleep_low',
        title: 'Rest & Recover',
        message: "You got less than 6 hours of sleep. Try to go to bed earlier tonight.",
        type: InsightType.warning,
        date: now,
        confidence: 'High',
      ));
    }

    // 4. Calorie Logic (if enabled)
    if (snapshot.caloriesConsumed > snapshot.caloriesGoal + 200) {
        insights.add(Insight(
        id: 'sugg_cal_over',
        title: 'Calorie Limit Exceeded',
        message: "You've exceeded your daily calorie goal.",
        type: InsightType.warning,
        date: now,
      ));
    }

    // 5. External signals (Consistency)
    if (consistencyScore != null && consistencyScore > 0.8) {
        insights.add(Insight(
        id: 'sugg_consistency_high',
        title: 'High Consistency',
        message: "Your logging consistency is excellent! data: ${(consistencyScore * 100).toInt()}%",
        type: InsightType.success,
        date: now,
      ));
    }

    return insights;
  }
  /// Alias for backward compatibility
  List<Insight> generateSuggestions(HealthSnapshot snapshot, UserProfile profile, {List<dynamic>? sleepEntries, double? consistencyScore}) => 
      generateInsights(snapshot, profile, sleepEntries: sleepEntries, consistencyScore: consistencyScore);
}
