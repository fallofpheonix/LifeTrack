


class ConsistencyService {
  /// Calculates the current logging streak in days.
  /// A streak is defined as consecutive days with at least one log.
  int calculateStreak(List<DateTime> logDates) {
    if (logDates.isEmpty) return 0;

    // Sort unique dates descending
    final uniqueDates = logDates
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (uniqueDates.isEmpty) return 0;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    // Check if the most recent log is today or yesterday
    // If most recent is older than yesterday, streak is broken (0) unless we want to show 
    // "current active streak" even if broken? Usually 0 if broken.
    final lastLog = uniqueDates.first;
    final diff = todayDate.difference(lastLog).inDays;
    
    if (diff > 1) {
      return 0; // Streak broken
    }
    
    int streak = 0;
    DateTime current = lastLog;
    
    for (var date in uniqueDates) {
      if (date.difference(current).inDays == 0) {
        // Same day (first iteration)
        streak++;
      } else if (date.difference(current).inDays == -1) {
        // Consecutive previous day
        streak++;
        current = date;
      } else {
        // Gap found
        break;
      }
    }
    
    return streak;
  }

  /// Generates a consistency score (0.0 to 1.0) based on last 7 days.
  double calculateWeeklyScore(List<DateTime> logDates) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(const Duration(days: 6)); // Last 7 days inclusive
    
    final logsInWeek = logDates.where((d) => !d.isBefore(startOfWeek)).map((d) => DateTime(d.year, d.month, d.day)).toSet();
    
    return logsInWeek.length / 7.0;
  }
  /// Alias for backward compatibility / interface compliance
  double calculateConsistencyScore(List<DateTime> logDates) => calculateWeeklyScore(logDates);
}
