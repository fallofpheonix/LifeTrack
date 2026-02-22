import 'package:lifetrack/data/models/sleep_entry.dart';

abstract class SleepRepository {
  Future<List<SleepEntry>> getSleepLogs({DateTime? start, DateTime? end, bool includeDeleted = false});
  Future<void> saveSleepLog(SleepEntry entry);
  Future<void> deleteSleepLog(String id);
}
