import 'api_client.dart';
import '../models/feedback_model.dart';

class FeedbackApi {
  static Future<bool> submitFeedback(FeedbackModel feedback) async {
    try {
      final response = await ApiClient.post('/feedback', feedback.toMap());
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
