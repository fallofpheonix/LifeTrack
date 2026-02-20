import 'package:flutter/material.dart';
import 'package:lifetrack/features/medical/tabs/my_records_tab.dart';
import 'package:lifetrack/features/medical/tabs/learn_tab.dart';
import 'package:lifetrack/features/medical/tabs/research_tab.dart';
import 'package:lifetrack/core/ui/app_page_layout.dart';

class MedicalPage extends StatelessWidget {
  const MedicalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Medical Hub'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Personal Log'),
              Tab(text: 'Health Library'),
              Tab(text: 'Insights'),
            ],
          ),
        ),
        body: const AppPageLayout(
          child: TabBarView(
            children: [
              MyRecordsTab(),
              LearnTab(),
              ResearchTab(),
            ],
          ),
        ),
      ),
    );
  }
}
