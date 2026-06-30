import 'dart:convert';
import 'api_client.dart';
import '../models/crop_calendar_model.dart';
import '../models/agri_resource_model.dart';
import '../models/mandi_price_model.dart';
import '../services/hive_service.dart';

class AgricultureApi {
  // ──────────────────────────────────────────────
  // CROP CALENDAR  →  GET /api/crop-calendar
  // ──────────────────────────────────────────────
  static Future<List<CropCalendarModel>> getCropCalendar() async {
    try {
      final villageId = HiveService.getUser()?.villageId;
      final endpoint =
          villageId != null ? '/crop-calendar?villageId=$villageId' : '/crop-calendar';

      final response = await ApiClient.get(endpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final items = data.map((j) => CropCalendarModel.fromMap(j)).toList();
        await HiveService.cacheCropCalendar(items);
        return items;
      }
      return HiveService.getCachedCropCalendar();
    } catch (_) {
      return HiveService.getCachedCropCalendar();
    }
  }

  // ──────────────────────────────────────────────
  // AGRI RESOURCES  →  GET /api/agri-resources
  // ──────────────────────────────────────────────
  static Future<List<AgriResourceModel>> getAgriResources() async {
    try {
      final villageId = HiveService.getUser()?.villageId;
      final endpoint =
          villageId != null ? '/agri-resources?villageId=$villageId' : '/agri-resources';

      final response = await ApiClient.get(endpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final items = data.map((j) => AgriResourceModel.fromMap(j)).toList();
        await HiveService.cacheAgriResources(items);
        return items;
      }
      return HiveService.getCachedAgriResources();
    } catch (_) {
      return HiveService.getCachedAgriResources();
    }
  }

  // ──────────────────────────────────────────────
  // MANDI PRICES  →  GET /api/mandi-prices
  // ──────────────────────────────────────────────
  static Future<List<MandiPriceModel>> getMandiPrices() async {
    try {
      final villageId = HiveService.getUser()?.villageId;
      final endpoint =
          villageId != null ? '/mandi-prices?villageId=$villageId' : '/mandi-prices';

      final response = await ApiClient.get(endpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final items = data.map((j) => MandiPriceModel.fromMap(j)).toList();
        await HiveService.cacheMandiPrices(items);
        return items;
      }
      return HiveService.getCachedMandiPrices();
    } catch (_) {
      return HiveService.getCachedMandiPrices();
    }
  }
}
