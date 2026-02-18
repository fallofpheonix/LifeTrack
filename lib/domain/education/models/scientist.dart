class Scientist {
  final String name;
  final String domain;
  final String fact;

  Scientist({
    required this.name,
    required this.domain,
    required this.fact,
  });

  factory Scientist.fromJson(Map<String, dynamic> json) {
    return Scientist(
      name: json['name'],
      domain: json['domain'],
      fact: json['fact'],
    );
  }
}
