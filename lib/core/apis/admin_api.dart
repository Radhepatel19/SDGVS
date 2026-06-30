import 'dart:convert';
import 'api_client.dart';
import '../models/admin_model.dart';

class AdminApi {
  static Future<AdminModel?> getAdminByVillageId(String villageId) async {
    try {
      final response = await ApiClient.get('/admins/village/$villageId');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AdminModel.fromMap(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
