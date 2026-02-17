class HealthSnapshot {
  HealthSnapshot({
    required this.steps,
    required this.stepsGoal,
    required this.waterGlasses,
    required this.waterGoal,
    required this.sleepHours,
    required this.calories,
    required this.caloriesGoal,
  });

  int steps;
  final int stepsGoal;
  int waterGlasses;
  final int waterGoal;
  double sleepHours;
  int calories;
  int caloriesGoal;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'steps': steps,
      'stepsGoal': stepsGoal,
      'waterGlasses': waterGlasses,
      'waterGoal': waterGoal,
      'sleepHours': sleepHours,
      'calories': calories,
      'caloriesGoal': caloriesGoal,
    };
  }

  factory HealthSnapshot.fromJson(Map<String, dynamic> json) {
    return HealthSnapshot(
      steps: json['steps'] as int? ?? 0,
      stepsGoal: json['stepsGoal'] as int? ?? 10000,
      waterGlasses: json['waterGlasses'] as int? ?? 0,
      waterGoal: json['waterGoal'] as int? ?? 8,
      sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? 0,
      calories: json['calories'] as int? ?? 0,
      caloriesGoal: json['caloriesGoal'] as int? ?? 2000,
    );
  }
}
