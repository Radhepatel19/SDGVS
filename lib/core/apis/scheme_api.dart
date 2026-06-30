import 'dart:convert';
import 'package:sdgvs/core/services/auth_service.dart';

import 'api_client.dart';
import '../models/scheme_model.dart';
import '../services/hive_service.dart';

class SchemeApi {
  static Future<List<SchemeModel>> getSchemes({String? category}) async {
    try {
      final endpoint = category != null ? '/schemes/category/$category' : '/schemes';
      final response = await ApiClient.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final schemes = data.map((json) => SchemeModel.fromMap(json)).toList();
        
        // Update Cache
        if (category == null) {
          await HiveService.cacheSchemes(schemes);
        }
        
        return schemes;
      }
      return [];
    } catch (e) {
      // Fallback to cache if offline
      return HiveService.getCachedSchemes(category: category);
    }
  }

  static Future<SchemeModel?> getSchemeById(String id) async {
    try {
      final response = await ApiClient.get('/schemes/$id');
      if (response.statusCode == 200) {
        return SchemeModel.fromMap(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<String>> getAvailableCategories() async {
    try {
      final response = await ApiClient.get('/schemes/categories');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  static Future<Map<String, dynamic>> applyForScheme(String schemeId) async {
    try {
      final user = await AuthService.getUser();
      if (user == null) return {'success': false, 'message': 'User not found'};

      final response = await ApiClient.post('/schemes/apply', {
        'user_id': user.id,
        'scheme_id': schemeId,
      });

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Application submitted successfully!'};
      }
      return {'success': false, 'message': 'Failed to submit application.'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
