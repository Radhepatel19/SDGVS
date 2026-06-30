import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class VoiceService extends ChangeNotifier {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isPlaying = false;
  String? _currentlySpeakingId;

  bool get isPlaying => _isPlaying;
  String? get currentlySpeakingId => _currentlySpeakingId;

  Future<void> init() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      _isPlaying = true;
      notifyListeners();
    });

    _tts.setCompletionHandler(() {
      _isPlaying = false;
      _currentlySpeakingId = null;
      notifyListeners();
    });

    _tts.setErrorHandler((msg) {
      _isPlaying = false;
      _currentlySpeakingId = null;
      notifyListeners();
      debugPrint("TTS Error: $msg");
    });
  }

  Future<void> speak(String text, {String? languageCode, String? id}) async {
    if (_isPlaying && _currentlySpeakingId == id) {
      await stop();
      return;
    }

    if (_isPlaying) {
      await stop();
    }

    if (languageCode != null) {
      // Map app language names to TTS codes
      String ttsLang = "en-US";
      switch (languageCode.toLowerCase()) {
        case 'hindi':
          ttsLang = "hi-IN";
          break;
        case 'gujarati':
          ttsLang = "gu-IN";
          break;
        default:
          ttsLang = "en-US";
      }
      await _tts.setLanguage(ttsLang);
    }

    _currentlySpeakingId = id;
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    _isPlaying = false;
    _currentlySpeakingId = null;
    notifyListeners();
  }
}

final voiceService = VoiceService();
