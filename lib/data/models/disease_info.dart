class DiseaseInfo {
  DiseaseInfo({
    required this.name,
    required this.symptoms,
    required this.precautions,
    required this.prevention,
    required this.cure,
    this.isApiResult = false,
    this.thumbnailUrl,
  });

  final String name;
  final String symptoms;
  final String precautions;
  final String prevention;
  final String cure;
  final bool isApiResult;
  final String? thumbnailUrl;
}
