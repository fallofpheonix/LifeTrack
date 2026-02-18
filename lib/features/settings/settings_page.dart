import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/services/life_track_store.dart';
import '../../core/services/data_governance_service.dart';
import '../../core/services/health_log.dart';
import '../../core/services/governance/export_policy.dart';
import '../../core/services/governance/anonymization_policy.dart';
import '../../core/settings/ui_preferences.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DataGovernanceService _governanceService = DataGovernanceService();
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final LifeTrackStore store = Provider.of<LifeTrackStore>(context);
    final ThemeMode currentTheme = store.themeMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          _buildSectionHeader('Appearance'),
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: currentTheme,
              onChanged: (ThemeMode? newValue) {
                if (newValue != null) {
                  store.updateTheme(newValue);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark'),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Reduce Motion'),
            subtitle: const Text('Minimize animations'),
            trailing: Switch(
              value: UiPreferences.reduceMotion,
              onChanged: (bool value) {
                // In real app, persist this preference
                // For now, it's just a mock toggle as UiPreferences needs update
                setState(() {
                   // Toggle logic would go here
                });
              },
            ),
          ),
          const Divider(),
          _buildSectionHeader('Sync & Backup'),
          const ListTile(
            leading: Icon(Icons.cloud_sync),
            title: Text('Sync Status'),
            subtitle: Text('Offline (Sync coming in Phase 6)'),
            trailing: Icon(Icons.cloud_off, color: Colors.grey),
          ),
          const Divider(),
          _buildSectionHeader('Data Governance'),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Retention Policy'),
            subtitle: const Text('Keep logs for 1 year'),
            onTap: () {
               // Show retention dialog
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Export Data'),
            subtitle: const Text('Export your health data as JSON'),
            onTap: () => _exportData(store),
            trailing: _isExporting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : null,
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Clear All Data', style: TextStyle(color: Colors.red)),
            onTap: () => _confirmClearData(store),
          ),
          const Divider(),
          _buildSectionHeader('About'),
          const ListTile(
            title: Text('Version'),
            subtitle: Text('1.0.0 (Phase 5)'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _exportData(LifeTrackStore store) async {
    setState(() => _isExporting = true);
    try {
      // 1. Get all data
      final Map<String, dynamic> rawData = await store.exportAll();

      // 2. Ask for options
      final ExportPolicy? policy = await showDialog<ExportPolicy>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Export Options'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ExportPolicy(scope: ExportScope.full, anonymizationPolicy: null)),
              child: const Padding(padding: EdgeInsets.all(8), child: Text('Full Export (Private)')),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ExportPolicy(scope: ExportScope.full, anonymizationPolicy: AnonymizationPolicy())),
              child: const Padding(padding: EdgeInsets.all(8), child: Text('Anonymized Export (Shareable)')),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ExportPolicy(scope: ExportScope.medical_only, anonymizationPolicy: null)),
              child: const Padding(padding: EdgeInsets.all(8), child: Text('Medical Data Only')),
            ),
          ],
        ),
      );

      if (policy == null) {
        setState(() => _isExporting = false);
        return; // Cancelled
      }

      // 3. Process
      final Map<String, dynamic> exportData = await _governanceService.exportData(rawData, policy: policy);
      final String jsonStr = jsonEncode(exportData);

      // 4. Share
      await Share.share(jsonStr, subject: 'LifeTrack Data Export');
      HealthLog.i('SettingsPage', 'Export', 'Data exported successfully');

    } catch (e, stack) {
      HealthLog.e('SettingsPage', 'Export', 'Export failed', error: e, stackTrace: stack);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _confirmClearData(LifeTrackStore store) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text('This action cannot be undone. All your health logs, profile, and settings will be permanently deleted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Delete Everything')
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await store.clearAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared.')));
        Navigator.pop(context); // Close settings
      }
    }
  }
}
