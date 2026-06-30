import 'dart:convert';
import 'package:sdgvs/core/services/auth_service.dart';
import 'api_client.dart';
import '../models/document_model.dart';
import '../services/hive_service.dart';

class LockerApi {
  static Future<List<DocumentModel>> getDocuments() async {
    try {
      final user = HiveService.getUser();
      if (user == null) return HiveService.getAllDocuments();

      final response = await ApiClient.get('/user-documents/user/${user.id}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final docs = data.map((json) => DocumentModel.fromMap(json)).toList();
        await HiveService.cacheDocuments(docs);
        return docs;         
      }
      return HiveService.getAllDocuments();
    } catch (e) {
      return HiveService.getAllDocuments();
    }
  }

  /// Uploads a document and returns the server-created [DocumentModel]
  /// (which contains the final Cloudinary URL in [filePath]), or null on failure.
  static Future<DocumentModel?> uploadDocument(DocumentModel doc) async {
    try {
       final user = await AuthService.getUser();
       if (user == null) return null;

       final Map<String, dynamic> payload = {
         'user_id': user.id,
         'title': doc.title,
         'type': doc.type,
       };

       final List<Map<String, dynamic>> files = [];
       if (doc.filePath != null && doc.filePath!.isNotEmpty && !doc.filePath!.startsWith('http')) {
         files.add({'field': 'file_path', 'path': doc.filePath});
       } else if (doc.filePath != null) {
         payload['file_path'] = doc.filePath;
       }

       final response = await ApiClient.postMultipart('/user-documents', payload, files);

       if (response.statusCode == 201 || response.statusCode == 200) {
         final json = jsonDecode(response.body);
         // Server returns { message: '...', data: { id, title, type, upload_date, file_path, ... } }
         final data = json['data'] as Map<String, dynamic>?;
         if (data != null) return DocumentModel.fromMap(data);
       }
       return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteDocument(String id) async {
    try {
      final response = await ApiClient.delete('/user-documents/$id');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
