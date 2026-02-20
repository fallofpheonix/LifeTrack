import 'dart:convert';

import 'package:flutter/services.dart';

class EducationDataSource {
  Future<List<T>> loadList<T>(
    String path,
    T Function(Map<String, dynamic>) mapper,
  ) async {
    final String raw = await rootBundle.loadString(path);
    final dynamic decoded = json.decode(raw);

    if (decoded is! List) {
      throw const FormatException('Expected a JSON array root.');
    }

    return decoded
        .cast<Map<String, dynamic>>()
        .map<T>(mapper)
        .toList(growable: false);
  }

  Future<List<String>> loadStringList(String path) async {
    final String raw = await rootBundle.loadString(path);
    final dynamic decoded = json.decode(raw);

    if (decoded is! List) {
      throw const FormatException('Expected a JSON array root.');
    }

    return decoded.map((dynamic e) => e.toString()).toList(growable: false);
  }
}
