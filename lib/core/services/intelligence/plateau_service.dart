import 'package:lifetrack/data/models/weight_entry.dart';
import 'package:lifetrack/core/services/health_log.dart';

class PlateauService {
  static const int _plateauThresholdDays = 14;
  static const double _weightToleranceKg = 0.5;

  /// Checks if weight has plateaued over the last [days] (default 14).
  /// A plateau is defined as variance within [tolerance] over the period.
  bool detectWeightPlateau(List<WeightEntry> history, {int days = _plateauThresholdDays, double tolerance = _weightToleranceKg}) {
    if (history.length < 3) return false; // Need enough data points

    final now = DateTime.now();
    final cutoff = now.subtract(Duration(days: days));
    
    // Get entries for the period, sorted by date asc

    // Get entries for the period, sorted by date asc

    final List<WeightEntry> recent = [];
    for (final e in history) {
        if (e.date.isAfter(cutoff)) {
            recent.add(e);
        }
    }

    recent.sort((WeightEntry a, WeightEntry b) => a.date.compareTo(b.date));

    if (recent.length < 3) return false; // Not enough separate logs in period

    // Check time span cover - must cover substantial part of the window?
    // Or just "if recent entries are flat". Let's assume recent entries being flat is enough.
    

    double minWeight = double.infinity;
    double maxWeight = double.negativeInfinity;
    
    for (final entry in recent) {
        if (entry.weightKg < minWeight) minWeight = entry.weightKg;
        if (entry.weightKg > maxWeight) maxWeight = entry.weightKg;
    }

    final variance = maxWeight - minWeight;

    if (variance <= tolerance) {
      HealthLog.i('PlateauService', 'Weight', 'Plateau detected. Variance: \${variance}kg over \${recent.length} entries');
      return true;
    }
    
    return false;
  }
}
