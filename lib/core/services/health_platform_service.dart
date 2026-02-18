/// Prototype for Phase 7: Device & Sensor Integration
/// This service abstracts the connection to on-device health platforms like
/// Google Fit (Android) and Apple Health (iOS).

abstract class HealthDataProvider {
  Future<bool> requestPermissions();
  Future<int> getSteps(DateTime start, DateTime end);
  Future<double> getWeight(DateTime start, DateTime end);
  Future<void> writeWeight(double weight, DateTime date);
}

class GoogleFitProvider implements HealthDataProvider {
  @override
  Future<bool> requestPermissions() async {
    // TODO: Implement Google Sign-In and Fitness API scope request
    return true;
  }

  @override
  Future<int> getSteps(DateTime start, DateTime end) async {
    // TODO: Call Fitness.HistoryApi.readData
    return 0;
  }

  @override
  Future<double> getWeight(DateTime start, DateTime end) async {
    // TODO: Call Fitness.HistoryApi.readData for DataType.TYPE_WEIGHT
    return 70.0;
  }

  @override
  Future<void> writeWeight(double weight, DateTime date) async {
    // TODO: Call Fitness.HistoryApi.insert
  }
}

class AppleHealthProvider implements HealthDataProvider {
  @override
  Future<bool> requestPermissions() async {
    // TODO: Implement HealthKit Store requestAuthorization
    return true;
  }

  @override
  Future<int> getSteps(DateTime start, DateTime end) async {
    // TODO: Query HKQuantityTypeIdentifierStepCount
    return 0;
  }

  @override
  Future<double> getWeight(DateTime start, DateTime end) async {
    // TODO: Query HKQuantityTypeIdentifierBodyMass
    return 70.0;
  }

  @override
  Future<void> writeWeight(double weight, DateTime date) async {
    // TODO: Save HKObject
  }
}
