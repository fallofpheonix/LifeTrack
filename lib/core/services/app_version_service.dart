import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'health_log.dart';

class AppVersionService {
  static const String _lastVersionKey = 'app_last_version';

  static Future<void> checkVersionAndMigrate() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? lastVersion = prefs.getString(_lastVersionKey);

      if (lastVersion == null) {
        HealthLog.i('AppVersionService', 'Install', 'Fresh install detected: $currentVersion');
        // Fresh install logic if needed
      } else if (lastVersion != currentVersion) {
        HealthLog.i('AppVersionService', 'Update', 'App update detected: $lastVersion -> $currentVersion');
        await _runMigrations(lastVersion, currentVersion);
        // Show "What's New" dialog flag could be set here
      } else {
        HealthLog.d('AppVersionService', 'Check', 'App version checked: $currentVersion (No change)');
      }

      await prefs.setString(_lastVersionKey, currentVersion);
    } catch (e, stack) {
      HealthLog.e('AppVersionService', 'Check', 'Version check failed', error: e, stackTrace: stack);
    }
  }

  static Future<void> _runMigrations(String oldVer, String newVer) async {
    // Example migration logic
    // if (oldVer == '1.0.0' && newVer == '1.1.0') { ... }
    HealthLog.i('AppVersionService', 'Migration', 'Running migrations...');
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate work
    HealthLog.i('AppVersionService', 'Migration', 'Migrations completed.');
  }
}
