import 'dart:math';

import 'health_log.dart';
import '../../data/models/sync/sync_operation.dart';

class MockBackend {
  final Random _random = Random();

  /// Simulates syncing a batch of operations.
  /// Returns a list of failed operation IDs.
  Future<List<String>> syncBatch(List<SyncOperation> operations) async {
    final List<String> failedIds = [];

    // Simulate network latency
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));

    // Simulate random network failure (10% chance)
    if (_random.nextDouble() < 0.1) {
       HealthLog.w('MockBackend', 'Failure', 'Simulated network failure - Connection refused');
       throw Exception('Network Error');
    }

    for (var op in operations) {
      try {
        // Simulate processing per item
        await _processOperation(op);
      } catch (e) {
        HealthLog.w('MockBackend', 'Sync', 'Failed to sync operation ${op.id}', error: e);
        failedIds.add(op.id);
      }
    }

    return failedIds;
  }

  Future<void> _processOperation(SyncOperation op) async {
     // Simulate server logic
     if (op.payload.containsKey('force_fail')) {
       throw Exception('Simulated server rejection');
     }
     HealthLog.i('MockBackend', 'Sync', 'Synced ${op.type.name} to ${op.entityTable}');
  }
}
