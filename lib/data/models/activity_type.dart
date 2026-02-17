import 'package:flutter/material.dart';

enum ActivityType {
  run,
  walk,
  cycle,
  yoga,
  gym,
  swim,
  hike,
  other;

  String get displayName {
    switch (this) {
      case ActivityType.run: return 'Running';
      case ActivityType.walk: return 'Walking';
      case ActivityType.cycle: return 'Cycling';
      case ActivityType.yoga: return 'Yoga';
      case ActivityType.gym: return 'Gym Workout';
      case ActivityType.swim: return 'Swimming';
      case ActivityType.hike: return 'Hiking';
      case ActivityType.other: return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityType.run: return Icons.directions_run;
      case ActivityType.walk: return Icons.directions_walk;
      case ActivityType.cycle: return Icons.directions_bike;
      case ActivityType.yoga: return Icons.self_improvement;
      case ActivityType.gym: return Icons.fitness_center;
      case ActivityType.swim: return Icons.pool;
      case ActivityType.hike: return Icons.landscape;
      case ActivityType.other: return Icons.accessibility_new;
    }
  }

  // Approx calories per minute for average weight
  int get caloriesPerMinute {
    switch (this) {
      case ActivityType.run: return 12;
      case ActivityType.walk: return 5;
      case ActivityType.cycle: return 8;
      case ActivityType.yoga: return 4;
      case ActivityType.gym: return 7;
      case ActivityType.swim: return 10;
      case ActivityType.hike: return 7;
      case ActivityType.other: return 6;
    }
  }
}
