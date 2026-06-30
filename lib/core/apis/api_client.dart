import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Use 10.0.2.2 for Android Emulator to hit localhost, or your machines IP
  static const String baseUrl = 'http://10.106.211.40:3000/api';
  

  static Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String endpoint) async {
   final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    return await http.get(url, headers: headers);
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    return await http.post(url, headers: headers, body: jsonEncode(body));
  }

  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    return await http.put(url, headers: headers, body: jsonEncode(body));
  }

  static Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    return await http.delete(url, headers: headers);
  }

  static Future<http.Response> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    return await http.patch(url, headers: headers, body: jsonEncode(body));
  }

  static Future<http.Response> postMultipart(
    String endpoint,
    Map<String, dynamic> body,
    List<Map<String, dynamic>> files, // Format: [{'field': 'imagePath', 'path': '/path/to/file'}]
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    
    var request = http.MultipartRequest('POST', url);
    
    // Add headers, exclude content-type since MultipartRequest handles it
    headers.forEach((key, value) {
      if (key.toLowerCase() != 'content-type') {
        request.headers[key] = value;
      }
    });

    // Add body fields
    body.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });

     for (var file in files) {
      if (file['path'] != null && file['path'].toString().isNotEmpty) {
        // If it's a URL, we don't upload it as multipart, we send it as a string field
        if (file['path'].toString().startsWith('http')) {
          request.fields[file['field']] = file['path'];
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(file['field'], file['path']),
          );
        }
      }
    }
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  static Future<http.Response> putMultipart(
    String endpoint,
    Map<String, dynamic> body,
    List<Map<String, dynamic>> files,
  ) async {
      final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    
    var request = http.MultipartRequest('PUT', url);
    
    headers.forEach((key, value) {
      if (key.toLowerCase() != 'content-type') {
        request.headers[key] = value;
      }
    });


      body.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });

       for (var file in files) {
      if (file['path'] != null && file['path'].toString().isNotEmpty) {
        if (file['path'].toString().startsWith('http')) {
          request.fields[file['field']] = file['path'];
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(file['field'], file['path']),
          );
          }
        }
      }
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);

  }
}
