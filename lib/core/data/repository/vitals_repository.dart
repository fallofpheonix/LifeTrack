import 'package:lifetrack/data/models/vitals/blood_pressure_entry.dart';
import 'package:lifetrack/data/models/vitals/heart_rate_entry.dart';
import 'package:lifetrack/data/models/vitals/glucose_entry.dart';
import 'package:lifetrack/data/models/weight_entry.dart';

abstract class VitalsRepository {
  // Blood Pressure
  Future<List<BloodPressureEntry>> getBP({DateTime? start, DateTime? end, bool includeDeleted = false});
  Future<void> saveBP(BloodPressureEntry entry);
  Future<void> deleteBP(String id);

  // Heart Rate
  Future<List<HeartRateEntry>> getHeartRate({DateTime? start, DateTime? end, bool includeDeleted = false});
  Future<void> saveHeartRate(HeartRateEntry entry);
  Future<void> deleteHeartRate(String id);

  // Glucose
  Future<List<GlucoseEntry>> getGlucose({DateTime? start, DateTime? end, bool includeDeleted = false});
  Future<void> saveGlucose(GlucoseEntry entry);
  Future<void> deleteGlucose(String id);

  // Weight
  Future<List<WeightEntry>> getWeight({DateTime? start, DateTime? end, bool includeDeleted = false});
  Future<void> saveWeight(WeightEntry entry);
  Future<void> deleteWeight(DateTime date);
}
