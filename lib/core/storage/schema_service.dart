import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SchemaService {
  static const String _schemaVersionKey = 'lifetrack_schema_version';
  static const int _currentVersion = 2; // Increment this when changing schema

  final SharedPreferences _prefs;

  SchemaService(this._prefs);

  static Future<SchemaService> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final SchemaService service = SchemaService(prefs);
    await service._migrate();
    return service;
  }

  Future<void> _migrate() async {
    final int storedVersion = _prefs.getInt(_schemaVersionKey) ?? 0;

    if (storedVersion < _currentVersion) {
      debugPrint('Migrating schema from v$storedVersion to v$_currentVersion...');
      
      if (storedVersion < 1) {
        // Migration to v1 (Initial setup - usually clean slate or legacy conversion)
        // Since we are post-Phase 1, we assume v1 is the baseline state.
      }

      if (storedVersion < 2) {
        await _migrateV1toV2();
      }

      await _prefs.setInt(_schemaVersionKey, _currentVersion);
      debugPrint('Schema migration completed.');
    }
  }

  Future<void> _migrateV1toV2() async {
    // Example migration: If we renamed a key or changed data format.
    // For now, ensuring strict unit structures are initialized if missing.
    // This is where we would map old "level" to "levelMgDl" if we had persisted data to convert.
    // Since we just changed the code, any old JSON with 'level' might break 'fromJson'.
    
    // Migration Logic for Glucose Entry: 'level' -> 'levelMgDl'
    const String glucoseKey = 'lifetrack_glucose';
    final String? rawGlucose = _prefs.getString(glucoseKey);
    
    if (rawGlucose != null && rawGlucose.contains('"level":')) {
      debugPrint('Migrating Glucose entries...');
      // Simple string replacement for this specific breaking change
      // In a complex app, we would decode to Map, transform, and re-encode.
      final String migratedDetails = rawGlucose.replaceAll('"level":', '"levelMgDl":');
      await _prefs.setString(glucoseKey, migratedDetails);
    }
  }
}
