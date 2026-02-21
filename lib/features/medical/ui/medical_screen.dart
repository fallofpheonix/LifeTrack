import 'package:flutter/material.dart';
import 'package:lifetrack/design_system/layout/screen_scaffold.dart';
import 'package:lifetrack/features/medical/ui/tabs/insights_tab.dart';
import 'package:lifetrack/features/medical/ui/tabs/library_tab.dart';
import 'package:lifetrack/features/medical/ui/tabs/records_tab.dart';

class MedicalScreen extends StatelessWidget {
  const MedicalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: ScreenScaffold(
        appBar: AppBar(
          title: const Text('Medical Hub'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Personal Log'),
              Tab(text: 'Health Library'),
              Tab(text: 'Insights'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            RecordsTab(),
            LibraryTab(),
            InsightsTab(),
          ],
        ),
      ),
    );
  }
}
