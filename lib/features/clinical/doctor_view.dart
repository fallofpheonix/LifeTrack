import 'package:flutter/material.dart';
import 'package:lifetrack/core/services/health_log.dart';

/// Prototype for Phase 9: Clinical Interaction Readiness
/// A specialized view for healthcare providers.

class DoctorView extends StatelessWidget {
  const DoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Summary'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
           Card(
             child: ListTile(
               title: Text('Vitals Overview (Last 30 Days)'),
               subtitle: Text('BP Average: 122/81\nResting HR: 68 bpm\nWeight: Stable'),
               isThreeLine: true,
             ),
           ),
           Card(
             child: ListTile(
               title: Text('Medication Adherence'),
               subtitle: Text('92% adherence rate.\nMissed: Metformin (2 doses)'),
               isThreeLine: true,
             ),
           ),
           Card(
             child: ListTile(
               title: Text('Recent Anomalies'),
               subtitle: Text('None detected in the last 14 days.'),
             ),
           ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ClinicalExportService().exportToFHIR();
        },
        label: const Text('Export FHIR'),
        icon: const Icon(Icons.share),
      ),
    );
  }
}

class ClinicalExportService {
  Future<void> exportToFHIR() async {
    // TODO: Generate FHIR JSON Bundle
    HealthLog.i('ClinicalExportService', 'Export', 'Exporting clinical data...');
  }
  
  Future<void> exportToPDF() async {
    // TODO: Generate PDF report
  }
}
