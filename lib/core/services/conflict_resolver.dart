import 'package:lifetrack/core/services/health_log.dart';

enum ResolutionPolicy { serverWins, clientWins, manualMerge }

class ConflictResolver {
  final ResolutionPolicy policy;

  ConflictResolver({this.policy = ResolutionPolicy.serverWins});

  /// Resolves conflict between local and remote data.
  /// Returns the resolved data map.
  Map<String, dynamic> resolve({
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    required String entityType, // e.g., 'medication', 'profile'
  }) {
    HealthLog.w('ConflictResolver', 'Conflict', 'Conflict detected for $entityType');
    
    if (policy == ResolutionPolicy.clientWins) {
      HealthLog.i('ConflictResolver', 'Resolution', 'Resolving with Client Wins');
      return localData;
    } else if (policy == ResolutionPolicy.serverWins) {
      HealthLog.i('ConflictResolver', 'Resolution', 'Resolving with Server Wins');
      return remoteData;
    } else {
      // Manual Merge (Stub - defaulting to server wins for now)
      // In a real app, this would trigger a UI flow or complex logic
      HealthLog.i('ConflictResolver', 'Resolution', 'Manual merge not implemented, defaulting to Server Wins');
      return remoteData;
    }
  }
}
