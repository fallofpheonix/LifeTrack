import 'package:flutter_test/flutter_test.dart';
import 'package:lifetrack/data/models/medication/medication.dart';
import 'package:lifetrack/core/validation/health_validator.dart';
import 'package:lifetrack/data/models/enums/data_source.dart';

import 'package:lifetrack/data/models/enums/frequency_type.dart';

void main() {
  group('Medication Model', () {
    test('should extend BaseHealthEntry and map startDate', () {
      final now = DateTime.now();
      final meds = Medication(
        id: '1',
        name: 'Aspirin',
        dosage: '81mg',
        frequencyType: FrequencyType.daily,
        startDate: now,
      );

      expect(meds.date, now);
      expect(meds.source, DataSource.manual);
      expect(meds.isDeleted, false);
      expect(meds.createdAt, isNotNull);
    });

    test('should serialize and deserialize correctly', () {
      final now = DateTime.now().toUtc();
      final meds = Medication(
        id: '1',
        name: 'Aspirin',
        dosage: '81mg',
        frequencyType: FrequencyType.daily,
        startDate: now,
        deletedAt: now,
      );

      final json = meds.toJson();
      final fromJson = Medication.fromJson(json);

      expect(fromJson.id, meds.id);
      expect(fromJson.isDeleted, true);
       // Time precision might differ slightly due to string conversion
      expect(fromJson.date.difference(meds.date).inMilliseconds.abs() < 100, true);
    });
  });

  group('HealthValidator', () {
    test('validateBloodPressure', () {
      expect(HealthValidator.validateBloodPressure(120, 80).isValid, isTrue);
      expect(HealthValidator.validateBloodPressure(null, 80).isValid, isFalse);
      expect(HealthValidator.validateBloodPressure(40, 80).isValid, isFalse); // Sys too low
      expect(HealthValidator.validateBloodPressure(120, 130).isValid, isFalse); // Dia > Sys
    });

    test('validateHeartRate', () {
      expect(HealthValidator.validateHeartRate(60).isValid, isTrue);
      expect(HealthValidator.validateHeartRate(20).isValid, isFalse);
      expect(HealthValidator.validateHeartRate(300).isValid, isFalse);
    });
  });
}
