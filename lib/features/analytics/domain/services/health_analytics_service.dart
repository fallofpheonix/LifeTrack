import 'package:lifetrack/domain/models/activity_entry.dart';
import 'package:lifetrack/domain/models/hydration_entry.dart';
import 'package:lifetrack/domain/models/nutrition_entry.dart';
import 'package:lifetrack/domain/models/vital_entry.dart';

class HealthAnalyticsService {
  const HealthAnalyticsService();

  int dailySteps(List<ActivityEntry> activities) {
    final int estimated = activities.fold<int>(0, (sum, entry) {
      final String t = entry.type.toLowerCase();
      if (t.contains('walk') || t.contains('run') || t.contains('cycle') || t.contains('steps')) {
        return sum + (entry.durationMinutes * 110);
      }
      return sum + (entry.durationMinutes * 70);
    });
    return estimated;
  }

  int calorieBurnEstimate(List<ActivityEntry> activities) {
    return activities.fold<int>(0, (sum, entry) => sum + entry.calories);
  }

  int hydrationTotal(List<HydrationEntry> hydrationEntries) {
    return hydrationEntries.fold<int>(0, (sum, entry) => sum + entry.glasses);
  }

  int nutritionCalories(List<NutritionEntry> nutritionEntries) {
    return nutritionEntries.fold<int>(0, (sum, entry) => sum + entry.calories);
  }

  int netCalorieBalance(List<ActivityEntry> activities, List<NutritionEntry> nutrition) {
    final int intake = nutritionCalories(nutrition);
    final int burned = calorieBurnEstimate(activities);
    return intake - burned;
  }

  Duration sleepDuration(List<VitalEntry> vitals) {
    final double hours = vitals
        .where((entry) => entry.metricType.toLowerCase() == 'sleep_hours')
        .fold<double>(0, (sum, entry) => sum + entry.value);
    return Duration(minutes: (hours * 60).round());
  }
}
