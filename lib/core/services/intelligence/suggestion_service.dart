import '../../../data/models/intelligence/insight.dart';
import '../../../data/models/sleep_entry.dart';

class SuggestionService {
  
  List<Insight> generateSuggestions({
    List<SleepEntry>? sleepEntries,
    double? consistencyScore,
  }) {
    final insights = <Insight>[];

    if (sleepEntries != null) {
      insights.addAll(_analyzeSleep(sleepEntries));
    }

    if (consistencyScore != null) {
      // Consistency insights
      if (consistencyScore > 0.8) {
        insights.add(Insight(
          id: 'consistency_high',
          title: 'Great Habit!',
          message: 'You have been very consistent with logging your health data.',
          type: InsightType.success,
          date: DateTime.now(),
          confidence: 'High',
        ));
      } else if (consistencyScore < 0.3) {
        insights.add(Insight(
          id: 'consistency_low',
          title: 'Consistency Drop',
          message: 'Try to log at least once a day to get better insights.',
          type: InsightType.info,
          date: DateTime.now(),
          confidence: 'High',
        ));
      }
    }

    return insights;
  }

  List<Insight> _analyzeSleep(List<SleepEntry> entries) {
    if (entries.length < 3) return [];

    final insights = <Insight>[];
    // Sort descending
    final sorted = List<SleepEntry>.from(entries)..sort((a, b) => b.startTime.compareTo(a.startTime));
    final last3 = sorted.take(3).toList();

    // Check if avg duration < 6 hours
    final avgDuration = last3.map((e) => e.durationHours).reduce((a, b) => a + b) / last3.length;

    if (avgDuration < 6.0) {
      insights.add(Insight(
        id: 'sleep_low',
        title: 'Sleep Hygiene',
        message: 'You have averaged less than 6 hours of sleep for the last 3 nights.',
        type: InsightType.warning,
        date: DateTime.now(),
        actionLabel: 'Wind Down Early',
        confidence: 'Medium',
      ));
    }

    return insights;
  }
}
