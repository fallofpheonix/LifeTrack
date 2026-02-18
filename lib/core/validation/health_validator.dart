import 'package:lifetrack/core/validation/validation_result.dart';

class HealthValidator {
  static ValidationResult validateBloodPressure(int? systolic, int? diastolic) {
    if (systolic == null || diastolic == null) {
      return ValidationResult.failure('Both systolic and diastolic values are required.', code: 'BP_MISSING');
    }
    if (systolic < 50 || systolic > 300) {
      return ValidationResult.failure('Systolic must be between 50 and 300.', code: 'BP_SYS_RANGE');
    }
    if (diastolic < 30 || diastolic > 200) {
      return ValidationResult.failure('Diastolic must be between 30 and 200.', code: 'BP_DIA_RANGE');
    }
    if (diastolic >= systolic) {
      return ValidationResult.failure('Diastolic must be lower than systolic.', code: 'BP_LOGIC');
    }
    return ValidationResult.valid;
  }

  static ValidationResult validateHeartRate(int? bpm) {
    if (bpm == null) return ValidationResult.failure('Heart rate is required.', code: 'HR_MISSING');
    if (bpm < 30 || bpm > 250) {
      return ValidationResult.failure('Heart rate must be between 30 and 250 BPM.', code: 'HR_RANGE');
    }
    return ValidationResult.valid;
  }

  static ValidationResult validateGlucose(int? level) {
    if (level == null) return ValidationResult.failure('Glucose level is required.', code: 'GLUCOSE_MISSING');
    if (level < 20 || level > 1000) {
      return ValidationResult.failure('Glucose must be between 20 and 1000 mg/dL.', code: 'GLUCOSE_RANGE');
    }
    return ValidationResult.valid;
  }

  static ValidationResult validateWeight(double? weight) {
    if (weight == null) return ValidationResult.failure('Weight is required.', code: 'WEIGHT_MISSING');
    if (weight < 2.0 || weight > 500.0) {
      return ValidationResult.failure('Weight must be between 2 and 500 kg.', code: 'WEIGHT_RANGE');
    }
    return ValidationResult.valid;
  }
}
