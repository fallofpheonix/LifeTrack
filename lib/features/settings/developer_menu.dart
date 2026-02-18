import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


/// Hidden menu for developers to view logs and inspecting state.
class DeveloperMenu extends StatelessWidget {
  const DeveloperMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Developer Menu')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Export Logs'),
            subtitle: const Text('Copy recent session logs to clipboard'),
            trailing: const Icon(Icons.copy),
            onTap: () {
              // TODO: implement actual log buffer reading
              Clipboard.setData(const ClipboardData(text: "Mock Logs..."));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logs copied')),
              );
            },
          ),
          ListTile(
            title: const Text('Throw Test Exception'),
            subtitle: const Text('Test global error handler'),
            trailing: const Icon(Icons.bug_report),
            onTap: () {
              throw Exception('Test Exception triggered from Dev Menu');
            },
          ),
          ListTile(
            title: const Text('Reset Onboarding'),
            trailing: const Icon(Icons.restore),
            onTap: () {
              // TODO: clear flags
            },
          ),
        ],
      ),
    );
  }
}
