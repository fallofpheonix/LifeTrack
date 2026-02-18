import '../../../data/models/medication/medication.dart';
import '../../../data/models/medication/dose_log.dart';

abstract class MedicationRepository {
  // Medications
  Future<List<Medication>> getMedications({bool includeDeleted = false});
  Future<void> saveMedication(Medication medication);
  Future<void> deleteMedication(String id);

  // Dose Logs
  Future<List<DoseLog>> getDoseLogs({DateTime? start, DateTime? end, bool includeDeleted = false});
  Future<void> logDose(DoseLog log);
  Future<void> deleteDoseLog(String id);
}
