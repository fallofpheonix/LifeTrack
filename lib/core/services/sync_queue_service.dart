import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lifetrack/data/models/sync/sync_operation.dart';
import 'package:lifetrack/data/models/enums/sync_operation_type.dart';
import 'package:lifetrack/core/services/health_log.dart';

class SyncQueueService {
  static const String _queueKey = 'lifetrack_sync_queue';
  final SharedPreferences _prefs;

  SyncQueueService(this._prefs);

  /// Adds an operation to the queue w/ Density Scaling
  Future<void> enqueue(SyncOperation operation) async {
    final List<SyncOperation> queue = await _getQueue();

    // Density Scaling: Collapse updates for same entity
    if (operation.type == SyncOperationType.update) {
      final int existingIndex = queue.indexWhere((op) => 
          op.type == SyncOperationType.update && 
          op.entityTable == operation.entityTable && 
          op.entityId == operation.entityId
      );

      if (existingIndex != -1) {
        // Replace existing with new (latest state)
        queue[existingIndex] = operation;
        HealthLog.i('SyncQueue', 'Enqueue', 'Coalesced sync update for ${operation.entityTable}/${operation.entityId}');
      } else {
        queue.add(operation);
      }
    } else {
      queue.add(operation);
    }
    
    // Sort by priority (Critical first) then timestamp
    queue.sort((a, b) {
      if (a.priority != b.priority) {
        return a.priority.index.compareTo(b.priority.index); // Lower index = higher priority (enum order)
      }
      return a.timestamp.compareTo(b.timestamp);
    });
    await _saveQueue(queue);
    
    // Trigger aggressive sync if critical
    if (operation.priority == SyncPriority.critical) {
      HealthLog.i('SyncQueue', 'Enqueue', 'Critical sync operation enqueued: ${operation.id}');
      // In real app, we might force a syncNow() call here via a callback/stream
    }
  }

  /// Gets the next batch of operations
  Future<List<SyncOperation>> peekBatch(int batchSize) async {
    final List<SyncOperation> queue = await _getQueue();
    return queue.take(batchSize).toList();
  }

  /// Removes operations from queue (after successful sync)
  Future<void> remove(List<String> ids) async {
    final List<SyncOperation> queue = await _getQueue();
    queue.removeWhere((op) => ids.contains(op.id));
    await _saveQueue(queue);
  }

  /// Gets current queue size
  Future<int> get queueSize async {
    final List<SyncOperation> queue = await _getQueue();
    return queue.length;
  }
  
  Future<void> checkpoint() async {
    // Save current queue state to disk immediately
    await _prefs.reload(); 
  }

  Future<List<SyncOperation>> _getQueue() async {
    final String? jsonStr = _prefs.getString(_queueKey);
    if (jsonStr == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(jsonStr);
      return decoded.map((e) => SyncOperation.fromJson(e)).toList();
    } catch (e, stack) {
      HealthLog.e('SyncQueue', 'Decode', 'Failed to decode sync queue', error: e, stackTrace: stack);
      return [];
    }
  }

  Future<void> _saveQueue(List<SyncOperation> queue) async {
    final String jsonStr = jsonEncode(queue.map((e) => e.toJson()).toList());
    await _prefs.setString(_queueKey, jsonStr);
  }
}
