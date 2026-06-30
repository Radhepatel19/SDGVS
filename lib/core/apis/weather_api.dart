import 'dart:convert';
import 'api_client.dart';
import '../models/weather_alert_model.dart';
import '../services/hive_service.dart';

class WeatherApi {
  // ──────────────────────────────────────────────
  // ACTIVE ALERTS  →  GET /api/weather-alerts/active
  // ──────────────────────────────────────────────
  static Future<List<WeatherAlertModel>> getActiveAlerts() async {
    try {
      final villageId = HiveService.getUser()?.villageId;
      final endpoint = villageId != null
          ? '/weather-alerts/active?villageId=$villageId'
          : '/weather-alerts/active';

      final response = await ApiClient.get(endpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final alerts = data.map((j) => WeatherAlertModel.fromMap(j)).toList();
        await HiveService.cacheWeatherAlerts(alerts);
        return alerts;
      }
      return HiveService.getCachedWeatherAlerts();
    } catch (_) {
      return HiveService.getCachedWeatherAlerts();
    }
  }

  // ──────────────────────────────────────────────
  // ALL ALERTS  →  GET /api/weather-alerts
  // ──────────────────────────────────────────────
  static Future<List<WeatherAlertModel>> getAllAlerts() async {
    try {
      final villageId = HiveService.getUser()?.villageId;
      final endpoint = villageId != null
          ? '/weather-alerts?villageId=$villageId'
          : '/weather-alerts';

      final response = await ApiClient.get(endpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((j) => WeatherAlertModel.fromMap(j)).toList();
      }
      return HiveService.getCachedWeatherAlerts();
    } catch (_) {
      return HiveService.getCachedWeatherAlerts();
    }
  }
}
