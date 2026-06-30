import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';
import '../services/auth_service.dart';

class AuthApi {
  // Backend: POST /api/auth/generate-otp
  static Future<Map<String, dynamic>> generateOtp(String mobile) async {
    try {
      final response = await ApiClient.post('/auth/generate-otp', {
        'mobile': mobile,
      });
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return {
        'success': response.statusCode == 200,
        'message': body['message'] ?? '',
      };
    } catch (e) {
      return {'success': false, 'message': 'Could not connect to server.'};
    }
  }

  // Backend: POST /api/auth/check-mobile
  static Future<Map<String, dynamic>> checkMobile(String mobile) async {
    try {
      final response = await ApiClient.post('/auth/check-mobile', {
        'mobile': mobile,
      });
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return {
        'success': response.statusCode == 200,
        'exists': body['exists'] ?? false,
        'is_registered': body['is_registered'] ?? false,
        'message': body['message'] ?? '',
      };
    } catch (e) {
      return {'success': false, 'message': 'Could not connect to server.'};
    }
  }

  // Backend: POST /api/auth/user-verify
  static Future<Map<String, dynamic>> verifyOtp(String mobile, String otp) async {
    try {
      final response = await ApiClient.post('/auth/user-verify', {
        'mobile': mobile,
        'otp': otp,
      });

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final user = UserModel.fromMap(body['data']);
        final token = body['token'] as String?;

        // Persist session
        final prefs = await SharedPreferences.getInstance();
        if (token != null) await prefs.setString('auth_token', token);
        await prefs.setBool('is_logged_in', true);
        await AuthService.saveUser(user);

        return {'success': true, 'user': user};
      }

      return {'success': false, 'message': body['message'] ?? 'Verification failed.'};
    } catch (e) {
      return {'success': false, 'message': 'Could not connect to server.'};
    }
  }

  // Backend: POST /api/auth/complete-profile
  static Future<Map<String, dynamic>> completeProfile(UserModel user) async {
    try {
      final response = await ApiClient.post('/auth/complete-profile', user.toMap());
      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final updatedUser = UserModel.fromMap(body['data']);
        await AuthService.saveUser(updatedUser);
        return {'success': true, 'user': updatedUser};
      }
      return {'success': false, 'message': body['message'] ?? 'Profile setup failed.'};
    } catch (e) {
      return {'success': false, 'message': 'Could not connect to server.'};
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.setBool('is_logged_in', false);
    await HiveService.clearUser();
  }
}
