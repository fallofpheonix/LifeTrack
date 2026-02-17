class RecoveryDataPoint {
  RecoveryDataPoint({
    required this.month,
    required this.fastingGlucose,
    required this.postMealGlucose,
  });

  final String month;
  final int fastingGlucose;
  final int postMealGlucose;
}
