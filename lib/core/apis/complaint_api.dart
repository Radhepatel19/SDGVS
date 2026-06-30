import 'dart:convert';
import 'api_client.dart';
import '../models/complaint_model.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';

class ComplaintApi {
  // ──────────────────────────────────────────────
  // GET all complaints for this user
  // GET /api/complaints?userId=<id>
  // ──────────────────────────────────────────────
  static Future<List<ComplaintModel>> getComplaints() async {
    try {
      final UserModel? user = HiveService.getUser();
      final userId = user?.id;
      final endpoint =
          userId != null ? '/complaints?userId=$userId' : '/complaints';

      final response = await ApiClient.get(endpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((j) => ComplaintModel.fromMap(j)).toList();
      }
      return HiveService.getAllComplaints();
    } catch (_) {
      return HiveService.getAllComplaints();
    }
  }

  // ──────────────────────────────────────────────
  // CREATE complaint
  // POST /api/complaints
  // ──────────────────────────────────────────────
  static Future<Map<String, dynamic>> createComplaint(
      ComplaintModel complaint) async {
    try {
      final UserModel? user = HiveService.getUser();
      final payload = {
        ...complaint.toApiMap(),
        'user_id': user?.id ?? complaint.userId,
      };
      
      // Remove local paths from payload, as they'll be sent as files
      payload.remove('imagePath');
      payload.remove('voicePath');
      payload.removeWhere((_, v) => v == null); // strip nulls

      final List<Map<String, dynamic>> files = [];
      if (complaint.imagePath != null && complaint.imageUrl == null) {
        files.add({'field': 'imagePath', 'path': complaint.imagePath});
      }
      if (complaint.voicePath != null && complaint.audioUrl == null) {
        files.add({'field': 'voicePath', 'path': complaint.voicePath});
      }

      final response = await ApiClient.postMultipart('/complaints', payload, files);

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body);
        final savedComplaint = ComplaintModel.fromMap(body['data']);
        // Also cache locally (synced)
        await HiveService.addComplaint(savedComplaint, pendingSync: false);
        return {'success': true, 'complaint': savedComplaint};
      }

      final body = jsonDecode(response.body);
      return {
        'success': false,
        'message': body['message'] ?? 'Failed to submit complaint.',
      };
    } catch (_) {
      // Offline fallback — save with a temp local ID (pending sync)
      await HiveService.addComplaint(complaint, pendingSync: true);
      return {
        'success': false,
        'offline': true,
        'message': 'Saved offline. Will sync when connection restores.',
      };
    }
  }

  // ──────────────────────────────────────────────
  // DELETE complaint
  // DELETE /api/complaints/:id
  // ──────────────────────────────────────────────
  static Future<bool> deleteComplaint(String id) async {
    try {
      final response = await ApiClient.delete('/complaints/$id');
      if (response.statusCode == 200) {
        await HiveService.deleteComplaint(id);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
