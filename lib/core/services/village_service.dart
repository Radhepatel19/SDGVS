import 'dart:convert';
import '../apis/api_client.dart';
import '../models/village_model.dart';

class VillageService {
  static List<VillageModel>? _cachedVillages;
  static DateTime? _cacheTime;
  static const int _cacheDurationMinutes = 60;

  /// Get all villages from the backend
  static Future<List<VillageModel>> getAllVillages({
    bool forceRefresh = false,
  }) async {
    // Check cache validity
    if (_cachedVillages != null && _cacheTime != null && !forceRefresh) {
      final now = DateTime.now();
      final difference = now.difference(_cacheTime!).inMinutes;
      if (difference < _cacheDurationMinutes) {
        return _cachedVillages!;
      }
    }

    try {
      final response = await ApiClient.get('/villages');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> villagesData = data is List
            ? data
            : data['data'] ?? [];

        _cachedVillages = (villagesData)
            .map((v) => VillageModel.fromMap(v as Map<String, dynamic>))
            .toList();
        _cacheTime = DateTime.now();

        return _cachedVillages!;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Get unique districts from all villages
  static Future<List<String>> getDistricts({bool forceRefresh = false}) async {
    final villages = await getAllVillages(forceRefresh: forceRefresh);
    final districts = <String>{};
    for (var village in villages) {
      districts.add(village.district);
    }
    return districts.toList()..sort();
  }

  /// Get talukas for a specific district
  static Future<List<String>> getTalukas(
    String district, {
    bool forceRefresh = false,
  }) async {
    final villages = await getAllVillages(forceRefresh: forceRefresh);
    final talukas = <String>{};
    for (var village in villages) {
      if (village.district == district) {
        talukas.add(village.taluka);
      }
    }
    return talukas.toList()..sort();
  }

  /// Get villages for a specific district and taluka
  static Future<List<VillageModel>> getVillagesByDistrictAndTaluka(
    String district,
    String taluka, {
    bool forceRefresh = false,
  }) async {
    final villages = await getAllVillages(forceRefresh: forceRefresh);
    return villages
        .where((v) => v.district == district && v.taluka == taluka)
        .toList();
  }

  /// Get a specific village by ID
  static Future<VillageModel?> getVillageById(String id) async {
    try {
      final response = await ApiClient.get('/villages/$id');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final villageData = data['data'] ?? data;
        return VillageModel.fromMap(villageData as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Get a village by name and taluka
  static Future<VillageModel?> getVillageByNameAndTaluka(
    String name,
    String taluka,
  ) async {
    try {
      final response = await ApiClient.get(
        '/villages/search/by-name?name=$name&taluka=$taluka',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return VillageModel.fromMap(data as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Clear the cache
  static void clearCache() {
    _cachedVillages = null;
    _cacheTime = null;
  }
}
