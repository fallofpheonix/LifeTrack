import 'package:lifetrack/data/models/base_health_entry.dart';
import 'package:lifetrack/data/models/enums/data_source.dart';

class BloodPressureEntry extends BaseHealthEntry {
  BloodPressureEntry({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required super.date,
    super.source,
    super.createdAt,
    super.editedAt,
    super.deletedAt,
    super.entityVersion,
  });

  final String id;
  final int systolic;
  final int diastolic;

  bool get isHypertensive => systolic >= 140 || diastolic >= 90;
  bool get isElevated => (systolic >= 120 && systolic <= 129) && diastolic < 80;
  bool get isHypotensive => systolic < 90 || diastolic < 60;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      ...toBaseJson(),
    };
  }

  factory BloodPressureEntry.fromJson(Map<String, dynamic> json) {
    return BloodPressureEntry(
      id: json['id'] as String,
      systolic: json['systolic'] as int,
      diastolic: json['diastolic'] as int,
      date: DateTime.parse(json['date'] as String),
      source: DataSource.values.asNameMap()[json['source']] ?? DataSource.manual,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      entityVersion: json['entityVersion'] as int? ?? 1,
    );
  }
}
