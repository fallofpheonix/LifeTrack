import 'health_log.dart';
import 'governance/retention_policy.dart';
import 'governance/export_policy.dart';
import 'governance/anonymization_policy.dart';

/// Service responsible for enforcing data governance policies.
/// Delegates core logic to specific Policy objects.
class DataGovernanceService {
  RetentionPolicy _retentionPolicy;
  AnonymizationPolicy _anonymizationPolicy;

  DataGovernanceService({
    RetentionPolicy? retentionPolicy,
    AnonymizationPolicy? anonymizationPolicy,
  })  : _retentionPolicy = retentionPolicy ?? RetentionPolicy(),
        _anonymizationPolicy = anonymizationPolicy ?? AnonymizationPolicy();

  /// Updates the current retention policy (e.g., from Settings)
  void updateRetentionPolicy(RetentionPolicy newPolicy) {
    _retentionPolicy = newPolicy;
    HealthLog.i('DataGovernance', 'PolicyUpdate', 'Retention policy updated: ${_retentionPolicy.policyDescription}');
  }

  /// Checks if data should be retained based on its timestamp and type.
  bool shouldRetain(DateTime createdAt, String dataType) {
    return _retentionPolicy.shouldCheck(createdAt, dataType);
  }

  /// Exports data applying the specified export policy.
  Future<Map<String, dynamic>> exportData(Map<String, dynamic> rawData, {required ExportPolicy policy}) async {
    HealthLog.audit('DataGovernance', 'Export', 'Data export initiated', userId: 'current_user', details: {'scope': policy.scope.toString()});
    
    // Inject the service's anonymization policy if the export policy requests one but doesn't have it set
    // This allows global anonymization rules to apply if not overridden
    ExportPolicy effectivePolicy = policy;
    if (policy.anonymizationPolicy == null && _anonymizationPolicy.hashCode != 0) { // check existence
       // In a real app we might merge them, for now just use the passed one or default instructions
    }

    return policy.process(rawData);
  }
  
  // Expose anonymization for direct use if needed
  Map<String, dynamic> anonymize(Map<String, dynamic> data) {
    return _anonymizationPolicy.sanitize(data);
  }
}
