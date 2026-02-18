import 'dart:async';
import 'package:lifetrack/core/services/intelligence/intelligence_coordinator.dart';
import 'package:lifetrack/core/services/health_log.dart';

// Abstract interface for fetching data - in a real app this would be the Repositories

class IntelligenceScheduler {
  final IntelligenceCoordinator _coordinator;
  // We might need specific providers for sleep/weight if not all are BaseHealthEntry
  // But for simplicity let's assume valid casting or separate providers if needed.
  // Actually, Coordinator takes specific lists.
  
  // Let's keep it simple: The caller provides a callback that performs the fetch and calls coordinator
  final Future<void> Function(IntelligenceCoordinator) _onRunAnalysis;

  Timer? _timer;
  final Duration interval;

  IntelligenceScheduler({
    required Future<void> Function(IntelligenceCoordinator) onRunAnalysis,
    this.interval = const Duration(hours: 12),
    IntelligenceCoordinator? coordinator,
  })  : _onRunAnalysis = onRunAnalysis,
        _coordinator = coordinator ?? IntelligenceCoordinator();

  void start() {
    _timer?.cancel();
    // Run immediately on start
    _run();
    _timer = Timer.periodic(interval, (_) => _run());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _run() async {
    try {
      await _onRunAnalysis(_coordinator);
    } catch (e) {
      // Log error (HealthLog.error)
      HealthLog.e('IntelligenceScheduler', 'Run', 'Analysis failed', error: e);
    }
  }
}
