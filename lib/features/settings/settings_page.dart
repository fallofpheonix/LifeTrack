import 'package:lifetrack/core/ui/app_page_layout.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:lifetrack/core/state/store_provider.dart';
import 'package:lifetrack/core/services/life_track_store.dart';
import 'package:lifetrack/core/services/data_governance_service.dart';
import 'package:lifetrack/core/services/health_log.dart';
import 'package:lifetrack/core/services/governance/export_policy.dart';
import 'package:lifetrack/core/services/governance/anonymization_policy.dart';
import 'package:lifetrack/core/settings/ui_preferences.dart';
import 'package:lifetrack/core/theme/app_colors_extension.dart';
import 'package:lifetrack/design_system/layout/screen_scaffold.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final DataGovernanceService _governanceService = DataGovernanceService();
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final LifeTrackStore store = ref.watch(lifeTrackStoreProvider);
    final ThemeMode currentTheme = store.themeMode;

    return ScreenScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: AppPageLayout(
        child: ListView(
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
          ListTile(
            leading: const Icon(Icons.cloud_sync),
            title: const Text('Sync Status'),
            subtitle: const Text('Offline (Sync coming in Phase 6)'),
            trailing: Icon(Icons.cloud_off, color: context.appColors.textSecondary),
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
            leading: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
            title: Text('Clear All Data', style: TextStyle(color: Theme.of(context).colorScheme.error)),
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
    ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
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

      if (!mounted) return;

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
              onPressed: () => Navigator.pop(context, ExportPolicy(scope: ExportScope.medicalOnly, anonymizationPolicy: null)),
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

      // Using Share.share (Standard) - ignoring deprecation for now to ensure build compatibility
      // ignore: deprecated_member_use
      await share_plus.Share.share(jsonStr, subject: 'LifeTrack Data Export');
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
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete Everything'),
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
