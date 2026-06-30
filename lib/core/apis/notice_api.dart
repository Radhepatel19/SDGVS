import 'dart:convert';
import 'api_client.dart';
import '../models/notice_model.dart';
import '../services/hive_service.dart';
import '../services/auth_service.dart';

class NoticeApi {
  static Future<List<NoticeModel>> getNotices() async {
    try {
      final user = await AuthService.getUser();
      String endpoint = '/notices';
      if (user != null && user.villageId != null && user.villageId!.isNotEmpty) {
        endpoint += '?village_id=${user.villageId}';
      }
      final response = await ApiClient.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final notices = data.map((json) => NoticeModel.fromMap(json)).toList();

        notices.sort((a, b) {
          if (a.priorityOrder == null && b.priorityOrder == null) return 0;
          if (a.priorityOrder == null) return 1;
          if (b.priorityOrder == null) return -1;
          return a.priorityOrder!.compareTo(b.priorityOrder!);
        });

        await HiveService.cacheNotices(notices);
        return notices;
      }
      return HiveService.getCachedNotices();
    } catch (e) {
      return HiveService.getCachedNotices();
    }
  }
}
