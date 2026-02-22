import 'package:lifetrack/core/services/health_log.dart';

/// Service responsible for enforcing data governance policies locally.
class DataGovernanceService {
  int _retentionDays;

  DataGovernanceService({
    int retentionDays = 365, // Default 1 year
  }) : _retentionDays = retentionDays;

  /// Updates the current retention policy (e.g., from Settings)
  void updateRetentionPolicy(int days) {
    _retentionDays = days;
    HealthLog.i('DataGovernance', 'PolicyUpdate', 'Retention policy updated to $days days');
  }

  /// Checks if data should be retained based on its timestamp and type.
  bool shouldCheck(DateTime createdAt, String dataType) {
    final now = DateTime.now();
    final difference = now.difference(createdAt).inDays;
    return difference <= _retentionDays;
  }

  /// Alias for compatibility with LifeTrackStore calls
  bool shouldRetain(DateTime createdAt, String dataType) => shouldCheck(createdAt, dataType);

  /// Exports data in a simple JSON format.
  Future<Map<String, dynamic>> exportData(Map<String, dynamic> rawData) async {
    HealthLog.audit('DataGovernance', 'Export', 'Data export initiated', userId: 'user');
    
    // Add simple metadata
    final result = Map<String, dynamic>.from(rawData);
    result['export_metadata'] = {
      'generated_at': DateTime.now().toUtc().toIso8601String(),
      'version': '1.0.0',
    };

    return result;
  }
}
