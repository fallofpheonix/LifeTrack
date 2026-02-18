import '../../../data/models/base_health_entry.dart';

class ConsistencyService {
  /// Calculates the consistency score (0.0 - 1.0) based on logging in the last 30 days.
  /// A score of 1.0 means the user logged every day.
  double calculateConsistencyScore(List<BaseHealthEntry> entries) {
    if (entries.isEmpty) return 0.0;

    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    // Filter entries from the last 30 days
    final recentEntries = entries.where((e) => e.date.isAfter(thirtyDaysAgo)).toList();
    if (recentEntries.isEmpty) return 0.0;

    // Get unique days logged
    final uniqueDays = <String>{};
    for (final entry in recentEntries) {
      final dateKey = '${entry.date.year}-${entry.date.month}-${entry.date.day}';
      uniqueDays.add(dateKey);
    }

    // Score = unique days logged / 30
    return (uniqueDays.length / 30.0).clamp(0.0, 1.0);
  }

  /// Calculates the current streak of consecutive days logged.
  int getStreak(List<BaseHealthEntry> entries) {
    if (entries.isEmpty) return 0;

    // Sort entries by date descending
    final sortedEntries = List<BaseHealthEntry>.from(entries)
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Check if user logged today or yesterday to keep streak alive
    if (sortedEntries.first.date.isBefore(today.subtract(const Duration(days: 1)))) {
       // If last log was before yesterday, streak is broken (unless we strictly count from today backwards)
       // Let's assume standard app behavior: if you missed yesterday, streak is 0. 
       // If you logged today, streak starts from today.
       // If you haven't logged today yet but logged yesterday, streak is valid.
    }

    DateTime? lastDate;

    for (final entry in sortedEntries) {
      final entryDate = DateTime(entry.date.year, entry.date.month, entry.date.day);
      
      if (lastDate == null) {
        // First entry checked
        final diff = today.difference(entryDate).inDays;
        if (diff > 1) {
          // Break if last entry was more than 1 day ago
          return 0;
        }
        streak++;
        lastDate = entryDate;
      } else {
        final diff = lastDate.difference(entryDate).inDays;
        if (diff == 1) {
          streak++;
          lastDate = entryDate;
        } else if (diff > 1) {
          break; // Gap found
        }
        // If diff == 0, same day, continue
      }
    }

    return streak;
  }
}
