import 'package:lifetrack/domain/education/models/research_item.dart';
import 'package:lifetrack/domain/education/repositories/education_repository.dart';
import 'package:lifetrack/data/models/content/news_item.dart';

class NewsService {
  final EducationRepository _educationRepo;

  NewsService(this._educationRepo);

  Future<List<NewsItem>> fetchNews() async {
    try {
      final research = await _educationRepo.loadResearch();
      return research.map((r) => NewsItem(
        id: r.id,
        title: r.title,
        summary: r.summary,
        date: DateTime.now(), // Local content date
        source: r.source,
        link: r.link,
      )).toList();
    } catch (e) {
      return <NewsItem>[];
    }
  }
}
