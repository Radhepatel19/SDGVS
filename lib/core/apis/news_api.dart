import 'dart:convert';
import 'api_client.dart';
import '../models/news_model.dart';
import '../services/hive_service.dart';
import '../services/auth_service.dart';

class NewsApi {
  static Future<List<NewsModel>> getNews() async {
    try {
      final user = await AuthService.getUser();
      String endpoint = '/good-news?';
      List<String> queryParams = [];

      if (user != null && user.villageId != null && user.villageId!.isNotEmpty) {
        queryParams.add('village_id=${user.villageId}');
      }
      if (user != null && user.id.isNotEmpty) {
        queryParams.add('user_id=${user.id}');
      }

      endpoint += queryParams.join('&');

      final response = await ApiClient.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final news = data.map((json) => NewsModel.fromMap(json)).toList();
        await HiveService.cacheNews(news);
        return news;
      }
      return HiveService.getCachedNews();
    } catch (e) {
      return HiveService.getCachedNews();
    }
  }

  /// Toggle like/unlike for a news item. Returns {liked, likes} or null on failure.
  static Future<Map<String, dynamic>?> toggleLike(String newsId) async {
    try {
      final user = await AuthService.getUser();
      if (user == null || user.id.isEmpty) return null;

      final response = await ApiClient.put(
        '/good-news/$newsId/like',
        {'user_id': user.id},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'liked': data['liked'] ?? false,
          'likes': data['likes'] ?? 0,
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
