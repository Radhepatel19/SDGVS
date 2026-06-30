import 'dart:convert';
import 'api_client.dart';
import '../models/poll_model.dart';
import '../services/auth_service.dart';
import '../services/hive_service.dart';

class PollApi {
  static Future<List<PollModel>> getPolls() async {
    try {
      final user = await AuthService.getUser();
      String endpoint = '/polls';
      if (user != null && user.villageId != null && user.villageId!.isNotEmpty) {
        endpoint += '?village_id=${user.villageId}&user_id=${user.id}';
      } else if (user != null) {
        endpoint += '?user_id=${user.id}';
      }
      final response = await ApiClient.get(endpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final polls = data.map((json) => PollModel.fromMap(json)).toList();
        await HiveService.cachePolls(polls);
        return polls;
      }
      return HiveService.getCachedPolls();
    } catch (e) {
      return HiveService.getCachedPolls();
    }
  }

  static Future<String?> vote(String pollId, String optionId, int optionIndex) async {
    try {
      final user = await AuthService.getUser();
      if (user == null) return "No user found locally";

      final response = await ApiClient.post('/poll-votes', {
        'poll_id': pollId,
        'user_id': user.id,
        'option_id': optionId,
        'option_index': optionIndex,
      });
      if (response.statusCode == 201 || response.statusCode == 200) {
        await HiveService.recordLocalVote(pollId, optionIndex);
        return null; // Success!
      }
      
      return 'API Error Code ${response.statusCode}: ${response.body}';
    } catch (e) {
      return 'Exception: $e';
    }
  }
}
