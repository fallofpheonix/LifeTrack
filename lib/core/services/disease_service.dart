import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lifetrack/data/models/disease_info.dart';

class DiseaseService {
  Future<DiseaseInfo?> fetchDiseaseFromWiki(String query) async {
    try {
      final Uri url = Uri.parse('https://en.wikipedia.org/api/rest_v1/page/summary/$query');
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final dynamic json = jsonDecode(response.body);
        return DiseaseInfo(
          name: json['title'] as String,
          symptoms: json['description'] as String? ?? 'No description available.',
          precautions: json['extract'] as String? ?? 'No details available.',
          prevention: 'Consult a doctor for prevention strategies.',
          cure: 'Consult a doctor for treatment.',
          isApiResult: true,
          thumbnailUrl: json['thumbnail']?['source'] as String?,
        );
      }
    } catch (e) {
      debugPrint('Error fetching disease info: $e');
    }
    return null;
  }
}
