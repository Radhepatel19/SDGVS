import 'dart:convert';
import 'api_client.dart';
import '../models/notification_model.dart';
import '../services/hive_service.dart';

class NotificationApi {
  static Future<List<NotificationModel>> getNotifications() async {
    try {
      final user = HiveService.getUser();
      final admin = HiveService.getAdmin();
      final villageId = user?.villageId ?? admin?.villageId;

      final endpoint = villageId != null
          ? '/notifications?villageId=$villageId'
          : '/notifications';

      final response = await ApiClient.get(endpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final notifications = data.map((json) => NotificationModel.fromMap(json)).toList();
        await HiveService.cacheNotifications(notifications);
        return HiveService.getCachedNotifications();
      }
      return HiveService.getCachedNotifications();
    } catch (e) {
      return HiveService.getCachedNotifications();
    }
  }

  static Future<bool> markAsRead(String id) async {
    try {
      final response = await ApiClient.post('/notifications/$id/read', {});
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> markAllAsRead() async {
    try {
      final response = await ApiClient.post('/notifications/read-all', {});
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
