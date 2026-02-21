class VitalDailyAggregate {
  const VitalDailyAggregate({
    required this.day,
    required this.averageValue,
    required this.count,
  });

  final DateTime day;
  final double averageValue;
  final int count;
}

class ActivityDailyAggregate {
  const ActivityDailyAggregate({
    required this.day,
    required this.totalMinutes,
    required this.totalCalories,
  });

  final DateTime day;
  final int totalMinutes;
  final int totalCalories;
}

class HydrationDailyAggregate {
  const HydrationDailyAggregate({
    required this.day,
    required this.totalGlasses,
  });

  final DateTime day;
  final int totalGlasses;
}
