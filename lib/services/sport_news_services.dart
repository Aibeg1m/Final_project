import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class SportsNewsService {
  static const String apiKey = "45f7deda78c447d0875a3c5ffa1fae5b";

  static Future<List<NewsArticle>> fetch(String query) async {
    final uri = Uri.https(
      "newsapi.org",
      "/v2/everything",
      {
        "q": query,
        "language": "en",
        "pageSize": "10",
        "apiKey": apiKey,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Error loading news ${response.statusCode}");
    }

    final data = json.decode(response.body);

    return (data["articles"] as List)
        .map((e) => NewsArticle.fromJson(e))
        .toList();
  }
}
