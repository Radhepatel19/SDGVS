import 'dart:convert';
import 'api_client.dart';
import '../models/agri_notice_model.dart';
import '../services/hive_service.dart';

class AgriNoticeApi {
  // ──────────────────────────────────────────────
  // GET NOTICES  →  GET /api/agri-notices
  // ──────────────────────────────────────────────
  static Future<List<AgriNoticeModel>> getNotices() async {
    try {
      final villageId = HiveService.getUser()?.villageId;
      // NOTE: No /api/ prefix — ApiClient.baseUrl already includes /api
      final endpoint = villageId != null
          ? '/agri-notices?villageId=$villageId'
          : '/agri-notices';

      final response = await ApiClient.get(endpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final notices = data.map((j) => AgriNoticeModel.fromMap(j)).toList();
        await HiveService.cacheAgriNotices(notices);
        return notices;
      }
      return HiveService.getCachedAgriNotices();
    } catch (_) {
      return HiveService.getCachedAgriNotices();
    }
  }
}
