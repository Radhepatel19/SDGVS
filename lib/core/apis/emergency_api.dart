import 'dart:convert';
import 'api_client.dart';

class EmergencyApi {
  static Future<List<Map<String, dynamic>>> getEmergencyNumbers({String? villageId}) async {
    try {
      final String endpoint = villageId != null
          ? '/emergency-services?village_id=$villageId'
          : '/emergency-services';
      final response = await ApiClient.get(endpoint);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
