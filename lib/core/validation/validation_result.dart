class ValidationResult {
  final bool isValid;
  final String? code;
  final String? message;

  const ValidationResult({
    required this.isValid,
    this.code,
    this.message,
  });

  static const ValidationResult valid = ValidationResult(isValid: true);
  
  factory ValidationResult.failure(String message, {String? code}) {
    return ValidationResult(isValid: false, message: message, code: code);
  }
}
