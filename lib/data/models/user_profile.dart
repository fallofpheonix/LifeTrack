class UserProfile {
  UserProfile({
    String? id,
    this.name = 'User',
    this.age = 30,
    this.weight = 70.0,
    this.height = 170.0,
    this.gender = 'Not specified',
    this.bloodType = 'Unknown',
    this.medicalHistory = const [],
    this.allergies = const [],
    this.emergencyContactName = '',
    this.emergencyContactPhone = '',
    this.emergencyContactRelation = '',
    this.insuranceProvider = '',
    this.insurancePolicyNumber = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  final String id;
  /// The user's display name.
  final String name;
  /// Age in years.
  final int age;
  /// Weight in kilograms.
  final double weight;
  /// Height in centimeters.
  final double height;
  /// Gender identity.
  final String gender;
  /// Blood type (e.g., A+, O-).
  final String bloodType;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// List of past medical conditions or surgeries.
  final List<String> medicalHistory;
  
  /// List of known allergies (medication, food, etc.).
  final List<String> allergies;
  
  /// Emergency contact name.
  final String emergencyContactName;
  
  /// Emergency contact phone number.
  final String emergencyContactPhone;
  
  /// Relationship to the emergency contact.
  final String emergencyContactRelation;
  
  /// Insurance provider name.
  final String insuranceProvider;
  
  /// Insurance policy number.
  final String insurancePolicyNumber;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'bloodType': bloodType,
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'emergencyContactRelation': emergencyContactRelation,
      'insuranceProvider': insuranceProvider,
      'insurancePolicyNumber': insurancePolicyNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'User',
      age: json['age'] as int? ?? 30,
      weight: (json['weight'] as num?)?.toDouble() ?? 70.0,
      height: (json['height'] as num?)?.toDouble() ?? 170.0,
      gender: json['gender'] as String? ?? 'Not specified',
      bloodType: json['bloodType'] as String? ?? 'Unknown',
      medicalHistory: (json['medicalHistory'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      allergies: (json['allergies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      emergencyContactName: json['emergencyContactName'] as String? ?? '',
      emergencyContactPhone: json['emergencyContactPhone'] as String? ?? '',
      emergencyContactRelation: json['emergencyContactRelation'] as String? ?? '',
      insuranceProvider: json['insuranceProvider'] as String? ?? '',
      insurancePolicyNumber: json['insurancePolicyNumber'] as String? ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  double get bmi {
    if (height <= 0) return 0;
    final double hM = height / 100;
    return weight / (hM * hM);
  }

  double get bodyFatPercentage {
    final double b = bmi;
    if (b == 0) return 0;
    final int sex = (gender.toLowerCase().contains('male') && !gender.toLowerCase().contains('fe')) ? 1 : 0;
    return (1.20 * b) + (0.23 * age) - (10.8 * sex) - 5.4;
  }

  int get bmr {
    final int sexVal = (gender.toLowerCase().contains('male') && !gender.toLowerCase().contains('fe')) ? 5 : -161;
    final double val = (10 * weight) + (6.25 * height) - (5 * age) + sexVal;
    return val.toInt();
  }

  factory UserProfile.empty() {
    return UserProfile();
  }
}
