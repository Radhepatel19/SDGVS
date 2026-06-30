import 'dart:convert';
import 'api_client.dart';
import '../models/impact_model.dart';

class ImpactApi {
  static Future<UserImpactStats?> getUserImpactStats(String userId) async {
    try {
      final response = await ApiClient.get('/user-impact/$userId');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserImpactStats.fromMap(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<UserImpactStats>> getLeaderboard() async {
    try {
      final response = await ApiClient.get('/user-impact/leaderboard/top');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserImpactStats.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<RewardWinnerModel>> getMonthlyWinners() async {
    try {
      final response = await ApiClient.get('/reward-winners');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => RewardWinnerModel.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  static Future<List<ImpactBadge>> getUserBadges(String userId) async {
    try {
      final response = await ApiClient.get('/user-badges/user/$userId');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ImpactBadge.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> incrementStat(String userId, String field, {int count = 1}) async {
    try {
      final response = await ApiClient.patch('/user-impact/$userId/increment', {
        field: count,
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
