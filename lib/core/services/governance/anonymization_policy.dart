class AnonymizationPolicy {
  
  /// Fields that must always be removed during anonymization
  static const Set<String> _piiFields = {
    'user_profile',
    'device_id',
    'email',
    'phone',
    'full_name',
    'birth_date_full', // Keep year/month maybe?
    'location_precise',
  };

  /// Fields that should be scrubbed/masked
  static const Set<String> _sensitiveFields = {
    'note',
    'comments',
    'description',
  };

  /// Applies anonymization rules to a dataset.
  /// Returns a new map with PII removed and sensitive fields scrubbed.
  Map<String, dynamic> sanitize(Map<String, dynamic> data) {
    final Map<String, dynamic> clean = Map<String, dynamic>.from(data);
    
    // 1. Remove Top-Level PII
    for (final field in _piiFields) {
      clean.remove(field);
    }

    // 2. Recursive Scrubbing
    _scrubRecursive(clean);

    return clean;
  }

  void _scrubRecursive(dynamic node) {
    if (node is Map) {
      // Check keys to remove
      final keysToRemove = <String>[];
      for (final key in node.keys) {
        if (_sensitiveFields.contains(key)) {
          keysToRemove.add(key);
        } else {
          // Recurse
          _scrubRecursive(node[key]);
        }
      }
      for (final key in keysToRemove) {
        node.remove(key);
      }
    } else if (node is List) {
      for (final item in node) {
        _scrubRecursive(item);
      }
    }
  }
}
