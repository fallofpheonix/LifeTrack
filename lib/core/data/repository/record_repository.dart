import 'package:lifetrack/data/models/health_record_entry.dart';

abstract class RecordRepository {
  Future<List<HealthRecordEntry>> getRecords({DateTime? start, DateTime? end, bool includeDeleted = false});
  Future<void> saveRecord(HealthRecordEntry record);
  Future<void> deleteRecord(String id);
}
