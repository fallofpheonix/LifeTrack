import 'anonymization_policy.dart';

enum ExportScope { full, medical_only, logs_only, minimal }

class ExportPolicy {
  final ExportScope scope;
  final bool includeMetadata;
  final AnonymizationPolicy? anonymizationPolicy;

  ExportPolicy({
    this.scope = ExportScope.full,
    this.includeMetadata = true,
    this.anonymizationPolicy,
  });

  /// Processes raw data according to the export policy.
  /// Filters by scope and applies anonymization if a policy is present.
  Map<String, dynamic> process(Map<String, dynamic> rawData) {
    Map<String, dynamic> result = Map<String, dynamic>.from(rawData);

    // 1. Filter by Scope
    result = _applyScope(result);

    // 2. Apply Anonymization (if policy exists)
    if (anonymizationPolicy != null) {
      result = anonymizationPolicy!.sanitize(result);
    }

    // 3. Metadata
    if (includeMetadata) {
      result['export_metadata'] = {
        'generated_at': DateTime.now().toIso8601String(),
        'scope': scope.toString(),
        'anonymized': anonymizationPolicy != null,
      };
    } else {
      result.remove('generated_at');
      result.remove('version');
    }

    return result;
  }

  Map<String, dynamic> _applyScope(Map<String, dynamic> data) {
    if (scope == ExportScope.full) return data;

    final Map<String, dynamic> filtered = {};

    if (scope == ExportScope.medical_only) {
      // Allowlist for medical data
      const allowed = {
        'snapshot', 'records', 'weight_history', 'bp_history', 
        'hr_history', 'glucose_history', 'dose_logs', 'sleep_logs', 'activities'
      };
      for (final key in allowed) {
        if (data.containsKey(key)) filtered[key] = data[key];
      }
    }
    // Add other scopes as needed

    return filtered;
  }
}
