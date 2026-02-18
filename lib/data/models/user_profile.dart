class UserProfile {
  UserProfile({
    String? id,
    this.name = 'User',
    this.age = 30,
    this.weight = 70.0,
    this.height = 170.0,
    this.gender = 'Not specified',
    this.bloodType = 'Unknown',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  final String id;
  final String name;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final String bloodType;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'bloodType': bloodType,
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
