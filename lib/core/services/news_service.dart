import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../../data/models/news_item.dart';

class NewsService {
  // ScienceDaily Medical Technology RSS
  static const String _feedUrl = 'https://www.sciencedaily.com/rss/health_medicine/medical_technology.xml';

  Future<List<NewsItem>> fetchNews() async {
    try {
      final http.Response response = await http.get(Uri.parse(_feedUrl));
      if (response.statusCode == 200) {
        final XmlDocument document = XmlDocument.parse(response.body);
        final Iterable<XmlElement> items = document.findAllElements('item');
        return items.map((XmlElement node) {
          return NewsItem(
            title: node.findElements('title').single.innerText,
            link: node.findElements('link').single.innerText,
            pubDate: node.findElements('pubDate').single.innerText,
            description: node.findElements('description').single.innerText.replaceAll(RegExp(r'<[^>]*>'), ''), // Strip HTML
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('Error fetching news: $e');
    }
    return <NewsItem>[];
  }
}
