import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../apis/api_client.dart';
import 'hive_service.dart';

class AuthService {
  static const String _userKey = 'user_profile';
    static const String _tokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _isFirstTimeKey = 'is_first_time';

  static SharedPreferences? _prefs;

  /// Get SharedPreferences instance (cached)
  static Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// ================= LOGIN =================
  static Future<bool> login(String mobile, String password) async {
    try {
      final response = await ApiClient.post('/auth/login', {
        'mobile': mobile,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        
        final prefs = await _getPrefs();
        await prefs.setString(_tokenKey, data['token']);
        await prefs.setBool(_isLoggedInKey, true); // ✅ FIXED

        final user = UserModel.fromMap(data['user']);
        await saveUser(user);

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }


  /// ================= CHECK MOBILE =================
  static Future<Map<String, dynamic>> checkMobile(String mobile) async {
    try {
      final response = await ApiClient.post('/auth/check-mobile', {
        'mobile': mobile,
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'exists': false, 'error': 'Failed to check mobile'};
    } catch (e) {
      return {'exists': false, 'error': e.toString()};
    }
  }

  /// ================= COMPLETE PROFILE =================
  static Future<bool> completeProfile(UserModel user) async {
    try {
      final response = await ApiClient.post('/auth/complete-profile', user.toMap());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          final updatedUser = UserModel.fromMap(data['data']);
          await saveUser(updatedUser);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// ================= SAVE USER =================
  static Future<bool> saveUser(
    UserModel user, {
    bool syncToBackend = false,
  }) async {
    try {
      UserModel finalUser = user;

      if (syncToBackend) {
        final bool isNew = user.id.isEmpty;

        final response = isNew
            ? await ApiClient.post('/users', user.toMap())
            : (user.profileImage != null && !user.profileImage!.startsWith('http'))
                ? await ApiClient.putMultipart(
                    '/users/${user.id}',
                    user.toMap()..remove('profile_image_url'),
                    [{'field': 'profile_image', 'path': user.profileImage}]
                  )
                : await ApiClient.put('/users/${user.id}', user.toMap());

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          if (data['data'] != null) {
            finalUser = UserModel.fromMap(data['data']);
          }
        } else {
          return false;
        }
      }

      final prefs = await _getPrefs();
      final userJson = finalUser.toJson();
      await prefs.setString(_userKey, userJson);
      await prefs.setBool(_isLoggedInKey, true);


      // Save to Hive for offline/fast access
      await HiveService.saveUser(finalUser);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// ================= GET USER =================
  static Future<UserModel?> getUser() async {
    try {
      final prefs = await _getPrefs();
      final userJson = prefs.getString(_userKey);

      if (userJson != null && userJson.isNotEmpty) {
        try {
          return UserModel.fromJson(userJson);
        } catch (e) {
          return null;
        }
      }

      final hiveUser = HiveService.getUser();
      if (hiveUser != null) {
        return hiveUser;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// ================= LOGIN STATUS =================
  static Future<bool> isLoggedIn() async {
    final prefs = await _getPrefs();
    final hasToken = prefs.getString(_tokenKey) != null;
    final loggedInFlag = prefs.getBool(_isLoggedInKey) ?? false;
    return hasToken && loggedInFlag;
  }

  /// ================= TOKEN =================
  static Future<String?> getToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_tokenKey);
  }

  /// ================= VERIFY USER =================
  static Future<bool> isUserVerified() async {
    try {
      final response = await ApiClient.get('/auth/status');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final dynamic verifiedVal = data['isVerified'];
        
        // Handle potential bool/int/null types safely
        final bool isVerified = verifiedVal == true || verifiedVal == 1;

        // Update local cache if status changed
        final user = await getUser();
        if (user != null && user.isVerified != isVerified) {
          await saveUser(user.copyWith(isVerified: isVerified));
        }

        return isVerified;
      }

      // ✅ Handle token expired (ApiClient should have tried refresh, if we are still here, it failed)
      if (response.statusCode == 401) {
        await logout();
        return false;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// ================= LOGOUT =================
  static Future<void> logout() async {
    final prefs = await _getPrefs();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    await prefs.setBool(_isLoggedInKey, false);

    await HiveService.clearUser();
  }

  /// ================= FIRST TIME =================
  static Future<bool> isFirstTime() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_isFirstTimeKey) ?? true;
  }

  static Future<void> setFirstTimeCompleted() async {
    final prefs = await _getPrefs();
    await prefs.setBool(_isFirstTimeKey, false);
  }
}
