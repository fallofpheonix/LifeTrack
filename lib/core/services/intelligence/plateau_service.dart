import 'dart:math';
import '../../../data/models/vitals/blood_pressure_entry.dart';
import '../../../data/models/weight_entry.dart';

class PlateauService {
  
  /// Checks if weight has stagnated (variance < threshold) over the last 14 days.
  /// Returns true if plateau detected.
  bool detectWeightPlateau(List<WeightEntry> entries, {double varianceThreshold = 0.5}) {
    if (entries.length < 5) return false; // Need enough data points

    final now = DateTime.now();
    final fourteenDaysAgo = now.subtract(const Duration(days: 14));
    
    final recentEntries = entries.where((e) => e.date.isAfter(fourteenDaysAgo)).toList();
    if (recentEntries.length < 3) return false;

    // Calculate variance
    final weights = recentEntries.map((e) => e.weightKg).toList();
    final mean = weights.reduce((a, b) => a + b) / weights.length;
    
    final sumSquaredDiffs = weights.map((w) => pow(w - mean, 2)).reduce((a, b) => a + b);
    final variance = sumSquaredDiffs / weights.length;

    return variance < varianceThreshold;
  }

  /// Checks if BP has stabilized (variance < threshold) over the last 14 days.
  bool detectBPPlateau(List<BloodPressureEntry> entries, {double varianceThreshold = 5.0}) {
    if (entries.length < 5) return false;

    final now = DateTime.now();
    final fourteenDaysAgo = now.subtract(const Duration(days: 14));
    
    final recentEntries = entries.where((e) => e.date.isAfter(fourteenDaysAgo)).toList();
    if (recentEntries.length < 3) return false;

    // Check Systolic Variance
    final systolics = recentEntries.map((e) => e.systolic).toList();
    final meanSys = systolics.reduce((a, b) => a + b) / systolics.length;
    final sysVariance = systolics.map((s) => pow(s - meanSys, 2)).reduce((a, b) => a + b) / systolics.length;

    return sysVariance < varianceThreshold;
  }
}
