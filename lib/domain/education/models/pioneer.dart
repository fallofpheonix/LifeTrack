class Pioneer {
  final String name;
  final String contribution;
  final String relevance;
  final String image;

  Pioneer({
    required this.name,
    required this.contribution,
    required this.relevance,
    required this.image,
  });

  String get imageAsset => 'assets/medical/pioneers/$image';

  factory Pioneer.fromJson(Map<String, dynamic> j) {
    return Pioneer(
      name: j['name'] as String,
      contribution: j['contribution'] as String,
      relevance: j['relevance'] as String,
      image: j['image'] as String,
    );
  }
}
