import 'dart:convert';

import 'package:lifetrack/data/models/enums/sync_operation_type.dart';

class SyncOperation {
  final String id;
  final SyncOperationType type;
  final String entityTable; // e.g., 'medications', 'vitals'
  final String entityId;
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  final SyncPriority priority;
  int retryCount;

  SyncOperation({
    required this.id,
    required this.type,
    required this.entityTable,
    required this.entityId,
    required this.payload,
    required this.timestamp,
    this.priority = SyncPriority.normal,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'entityTable': entityTable,
      'entityId': entityId,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
      'priority': priority.index,
      'retryCount': retryCount,
    };
  }

  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    return SyncOperation(
      id: json['id'],
      type: SyncOperationType.values[json['type']],
      entityTable: json['entityTable'],
      entityId: json['entityId'],
      payload: Map<String, dynamic>.from(json['payload']),
      timestamp: DateTime.parse(json['timestamp']),
      priority: SyncPriority.values[json['priority'] ?? 1],
      retryCount: json['retryCount'] ?? 0,
    );
  }

  String toJsonString() => jsonEncode(toJson());
}
