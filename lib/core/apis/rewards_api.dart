import 'dart:convert';
import 'api_client.dart';
import '../../features/rewards/models/leaderboard_model.dart';
import '../../features/rewards/models/reward_winner.dart';

class RewardsApi {
  static Future<List<LeaderboardEntry>> getLeaderboard(
    String category, {
    String? villageId,
    String? occupation,
  }) async {
    try {
      String url = '/user-impact/leaderboard/top';
      final Map<String, String> queryParams = {};

      if (villageId != null) queryParams['villageId'] = villageId;
      if (occupation != null) queryParams['occupation'] = occupation;

      if (queryParams.isNotEmpty) {
        final String queryString = Uri(queryParameters: queryParams).query;
        url += '?$queryString';
      }

      final response = await ApiClient.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => LeaderboardEntry.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<RewardWinner>> getWinners({String? villageId}) async {
    try {
      String url = '/certificates';
      if (villageId != null && villageId.isNotEmpty) {
        url += '?village_id=$villageId';
      }
      final response = await ApiClient.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => RewardWinner.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
