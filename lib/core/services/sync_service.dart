import 'dart:async';
 
import 'package:lifetrack/core/services/sync_queue_service.dart';
import 'package:lifetrack/data/models/sync/sync_operation.dart';
import 'package:lifetrack/core/services/mock_backend.dart';
import 'package:lifetrack/core/services/health_log.dart';

class SyncService {
  final SyncQueueService _queueService;
  final MockBackend _backend;
  Timer? _syncTimer;
  bool _isSyncing = false;

  SyncService(this._queueService, this._backend);

  /// Starts the background sync loop
  void startSyncLoop() {
    _syncTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      syncNow();
    });
    // Listen to network changes (Stub - just basic check)
    // In real app, listen to connectivity stream.
    HealthLog.i('SyncService', 'Start', 'Sync loop started');
  }

  /// Manually triggers a sync
  Future<void> syncNow() async {
    if (_isSyncing) return;
    _isSyncing = true;
    HealthLog.i('SyncService', 'Run', 'Starting sync cycle');

    try {
      // 1. Check Network (Stubbed, assume online for now or unchecked)
      
      // 2. Process Queue
      await _processQueue();
      
    } catch (e, stack) {
      HealthLog.e('SyncService', 'Run', 'Sync cycle failed', error: e, stackTrace: stack);
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> triggerSync() => syncNow();

  Future<void> _processQueue() async {
    final int batchSize = 50; // Performance Budget constraint
    final List<SyncOperation> batch = await _queueService.peekBatch(batchSize);
    
    if (batch.isEmpty) {
      HealthLog.i('SyncService', 'Queue', 'Queue empty');
      return;
    }

    try {
      final List<String> failedIds = await _backend.syncBatch(batch);
      
      // Calculate success
      final List<String> successIds = batch
          .map((op) => op.id)
          .where((id) => !failedIds.contains(id))
          .toList();

      // Remove successful
      if (successIds.isNotEmpty) {
        await _queueService.remove(successIds);
        HealthLog.i('SyncService', 'Success', 'Synced ${successIds.length} operations');
      }

      // Handle failures (Simple retry logic: leave in queue, maybe increment retry count if we updated model)
      if (failedIds.isNotEmpty) {
        HealthLog.w('SyncService', 'Failure', 'Failed to sync ${failedIds.length} operations');
      }
      
      // Recurse if more data exists and we had successes (drain queue)
      if (successIds.isNotEmpty && await _queueService.queueSize > 0) {
        await _processQueue(); 
      }

    } catch (e) {
      // Backend outage
      HealthLog.w('SyncService', 'Error', 'Backend unreachable', error: e);
    }
  }

  void stop() {
    _syncTimer?.cancel();
  }
}
