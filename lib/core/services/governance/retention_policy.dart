class RetentionPolicy {
  // Constants for default retention periods
  static const Duration rawLogRetention = Duration(days: 365);
  static const Duration auditLogRetention = Duration(days: 180);
  static const Duration infiniteRetention = Duration(days: 99999); // Effectively infinite

  final Duration _rawLogDuration;
  final Duration _auditLogDuration;

  RetentionPolicy({
    Duration? rawLogDuration,
    Duration? auditLogDuration,
  })  : _rawLogDuration = rawLogDuration ?? rawLogRetention,
        _auditLogDuration = auditLogDuration ?? auditLogRetention;

  /// Determines if a record should be kept based on its type and creation timestamp.
  /// 
  /// [dataType] should be one of: 'raw_log', 'audit', 'medical_record', 'aggregate'.
  bool shouldCheck(DateTime createdAt, String dataType) {
    final Duration age = DateTime.now().difference(createdAt);

    switch (dataType) {
      case 'raw_log':
        // e.g., low-level debug logs, verbose sync logs
        return age <= _rawLogDuration;
      case 'audit':
        // Security and access logs
        return age <= _auditLogDuration;
      case 'medical_record':
      case 'aggregate':
        // User health data is kept indefinitely by default
        return true;
      default:
        // Default to safe retention (keep it) if unknown
        return true;
    }
  }

  /// Returns a description of the current policy for UI display.
  String get policyDescription {
    return 'Raw Logs: ${_rawLogDuration.inDays} days, Audit Logs: ${_auditLogDuration.inDays} days';
  }
}
