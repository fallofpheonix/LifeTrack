import '../base_health_entry.dart'; // Make sure this is here
import '../enums/data_source.dart';
import '../enums/frequency_type.dart';

class Medication extends BaseHealthEntry {
  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequencyType,
    this.intervalHours, // For interval type
    required DateTime startDate,
    DataSource source = DataSource.manual,
    DateTime? createdAt,
    DateTime? editedAt,
    DateTime? deletedAt,
    int entityVersion = 1,
  }) : super(
          date: startDate,
          source: source,
          createdAt: createdAt ?? DateTime.now().toUtc(),
          editedAt: editedAt,
          deletedAt: deletedAt,
          entityVersion: entityVersion,
        );

  final String id;
  final String name;
  final String dosage; // e.g., "500mg" or "1 tablet"
  final FrequencyType frequencyType;
  final int? intervalHours;

  DateTime get startDate => date;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequencyType': frequencyType.toString().split('.').last,
      'intervalHours': intervalHours,
      ...toBaseJson(),
      // We still include startDate for backward compatibility if needed, but it's redundant with date
      'startDate': date.toIso8601String(),
    };
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      frequencyType: FrequencyType.values.firstWhere(
            (FrequencyType e) => e.toString().split('.').last == json['frequencyType'],
        orElse: () => FrequencyType.daily,
      ),
      intervalHours: json['intervalHours'] as int?,
      startDate: DateTime.parse(json['startDate'] as String), // This will be passed to super.date
      source: DataSource.values.asNameMap()[json['source']] ?? DataSource.manual,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      entityVersion: json['entityVersion'] as int? ?? 1,
    );
  }
}
