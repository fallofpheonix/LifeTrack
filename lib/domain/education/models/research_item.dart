class ResearchItem {
  final String title;
  final String source;
  final String impact;

  ResearchItem({
    required this.title,
    required this.source,
    required this.impact,
  });

  factory ResearchItem.fromJson(Map<String, dynamic> j) {
    return ResearchItem(
      title: j['title'] as String,
      source: j['source'] as String,
      impact: j['impact'] as String,
    );
  }
}
