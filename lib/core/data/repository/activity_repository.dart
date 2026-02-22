import 'package:lifetrack/data/models/activity_log.dart';

abstract class ActivityRepository {
  Future<List<ActivityLog>> getActivities({DateTime? start, DateTime? end, bool includeDeleted = false});
  Future<void> saveActivity(ActivityLog log);
  Future<void> deleteActivity(String id);
}
