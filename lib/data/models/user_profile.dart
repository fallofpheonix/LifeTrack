class UserProfile {
  UserProfile({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.bloodType,
  });

  String name;
  int age;
  double weight;
  double height;
  String gender;
  String bloodType;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'bloodType': bloodType,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? 'User',
      age: json['age'] as int? ?? 30,
      weight: (json['weight'] as num?)?.toDouble() ?? 70.0,
      height: (json['height'] as num?)?.toDouble() ?? 170.0,
      gender: json['gender'] as String? ?? 'Not specified',
      bloodType: json['bloodType'] as String? ?? 'Unknown',
    );
  }

  double get bmi {
    if (height <= 0) return 0;
    final double hM = height / 100;
    return weight / (hM * hM);
  }

  double get bodyFatPercentage {
    // (1.20 * BMI) + (0.23 * Age) - (10.8 * sex) - 5.4.
    // Sex: 1 for male, 0 female.
    final double b = bmi;
    if (b == 0) return 0;
    final int sex = (gender.toLowerCase().contains('male') && !gender.toLowerCase().contains('fe')) ? 1 : 0;
    return (1.20 * b) + (0.23 * age) - (10.8 * sex) - 5.4;
  }

  int get bmr {
    // Mifflin-St Jeor: 10*weight + 6.25*height - 5*age + s (s=+5 male, -161 female).
    final int sexVal = (gender.toLowerCase().contains('male') && !gender.toLowerCase().contains('fe')) ? 5 : -161;
    final double val = (10 * weight) + (6.25 * height) - (5 * age) + sexVal;
    return val.toInt();
  }
  factory UserProfile.empty() {
    return UserProfile(
      name: 'User',
      age: 30,
      weight: 70.0,
      height: 170.0,
      gender: 'Not specified',
      bloodType: 'Unknown',
    );
  }
}
