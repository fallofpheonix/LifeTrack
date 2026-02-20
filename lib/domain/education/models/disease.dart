class Disease {
  final String name;
  final String desc;
  final String prevention;
  final String risk;

  Disease({
    required this.name,
    required this.desc,
    required this.prevention,
    required this.risk,
  });

  factory Disease.fromJson(Map<String, dynamic> j) {
    return Disease(
      name: j['name'] as String,
      desc: j['desc'] as String,
      prevention: j['prevention'] as String,
      risk: j['risk'] as String,
    );
  }
}
