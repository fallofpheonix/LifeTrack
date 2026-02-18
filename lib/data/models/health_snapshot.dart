class HealthSnapshot {
  final int steps;
  final int stepsGoal;
  final int waterGlasses;
  final int waterGoal;
  final double sleepHours;
  final int caloriesConsumed;
  final int caloriesGoal;
  final int caloriesBurned;

  const HealthSnapshot({
    required this.steps,
    required this.stepsGoal,
    required this.waterGlasses,
    required this.waterGoal,
    required this.sleepHours,
    required this.caloriesConsumed,
    required this.caloriesGoal,
    required this.caloriesBurned,
  });

  HealthSnapshot copyWith({
    int? steps,
    int? stepsGoal,
    int? waterGlasses,
    int? waterGoal,
    double? sleepHours,
    int? caloriesConsumed,
    int? caloriesGoal,
    int? caloriesBurned,
  }) {
    return HealthSnapshot(
      steps: steps ?? this.steps,
      stepsGoal: stepsGoal ?? this.stepsGoal,
      waterGlasses: waterGlasses ?? this.waterGlasses,
      waterGoal: waterGoal ?? this.waterGoal,
      sleepHours: sleepHours ?? this.sleepHours,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      caloriesGoal: caloriesGoal ?? this.caloriesGoal,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
    );
  }

  factory HealthSnapshot.empty() {
    return const HealthSnapshot(
      steps: 0,
      stepsGoal: 8000,
      waterGlasses: 0,
      waterGoal: 8,
      sleepHours: 0,
      caloriesConsumed: 0,
      caloriesGoal: 2000,
      caloriesBurned: 0,
    );
  }

  factory HealthSnapshot.fromJson(Map<String, dynamic> json) {
    return HealthSnapshot(
      steps: json['steps'] ?? 0,
      stepsGoal: json['stepsGoal'] ?? 8000,
      waterGlasses: json['waterGlasses'] ?? 0,
      waterGoal: json['waterGoal'] ?? 8,
      sleepHours: (json['sleepHours'] ?? 0).toDouble(),
      caloriesConsumed: json['caloriesConsumed'] ?? 0,
      caloriesGoal: json['caloriesGoal'] ?? 2000,
      caloriesBurned: json['caloriesBurned'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'stepsGoal': stepsGoal,
      'waterGlasses': waterGlasses,
      'waterGoal': waterGoal,
      'sleepHours': sleepHours,
      'caloriesConsumed': caloriesConsumed,
      'caloriesGoal': caloriesGoal,
      'caloriesBurned': caloriesBurned,
    };
  }
}
