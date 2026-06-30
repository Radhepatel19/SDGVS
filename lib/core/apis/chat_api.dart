import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../constants/app_constants.dart';

class ChatApi {
  // ── System context injected as a prefix to every user message ───────────
  static const String _systemContext = '''
You are a helpful Village Assistant for the SDGVS (Smart Digital Gramin Vikas Seva) app.
Your ONLY job is to answer questions strictly related to:

APP FEATURES:
- Complaints: how to submit, track, or view complaints
- Notices: village announcements and notices
- Polls: community voting and poll results
- Government Schemes: eligibility, benefits, how to apply
- Document Locker: storing and managing personal documents
- Emergency Services: contacting emergency numbers
- Good News: village achievements and positive news
- Certificates and Rewards: community contribution certificates
- Weather Alerts: local weather information
- Mandi Prices: agricultural commodity prices
- Crop Calendar: crop growing guidance
- Agricultural Resources: farming tips and resources
- Community: village community features
- Profile and Account: managing user profile

VILLAGE / RURAL LIFE TOPICS:
- Agriculture, farming practices, crop information
- Rural government services and schemes
- Village administration and governance
- Local community events and updates
- Rural health, sanitation, and water
- Village infrastructure and development

STRICT RULES:
- If a question is NOT related to the app or village/rural topics, say exactly this:
  "I can only help with questions about the SDGVS app and village-related topics. Please ask me something about the app features or your village needs."
- Always respond in simple, clear language.
- Keep responses concise and helpful.
- If asked in Hindi or Gujarati, respond in the same language.

Now answer the following user question:
''';

  static GenerativeModel? _model;

  static GenerativeModel _getModel() {
    _model ??= GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: AppConstants.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.3,
        maxOutputTokens: 512,
      ),
    );
    return _model!;
  }

  static Future<String> getResponse(String query) async {
    try {
      final model = _getModel();

      // Combine system context + user query into one prompt (most compatible)
      final fullPrompt = '$_systemContext$query';

      final response = await model.generateContent([
        Content.text(fullPrompt),
      ]);

      final text = response.text ?? '';
      if (text.trim().isEmpty) {
        return "I'm sorry, I couldn't generate a response. Please try again.";
      }
      return text.trim();
    } on GenerativeAIException catch (e) {
      debugPrint('❌ Gemini API Error: ${e.message}');
      final msg = e.message.toLowerCase();
      if (msg.contains('quota') || msg.contains('limit') || msg.contains('exceeded')) {
        return "⚠️ I'm a bit busy right now. Please wait a moment and try again.";
      }
      if (msg.contains('api key') || msg.contains('api_key') || msg.contains('invalid') || msg.contains('permission')) {
        return "⚠️ Assistant is temporarily unavailable. Please contact the app administrator.";
      }
      return "I'm having trouble right now. Please try again in a moment.";
    } catch (e) {
      debugPrint('❌ Unknown Error: $e');
      return "Network error. Please check your connection and try again.";
    }
  }
}
