import 'dart:async';
import 'package:hive/hive.dart';

import '../apis/impact_api.dart';
import '../services/auth_service.dart';

class ContributionService {
  static final ContributionService _instance = ContributionService._internal();
  factory ContributionService() => _instance;
  ContributionService._internal();

  Timer? _timer;
  int _secondsAccumulated = 0;
  static const int _hourInSeconds = 3600;
  static const String _secondsKey = 'accumulated_seconds';

  Future<void> startTracking() async {
    _timer?.cancel();
    
    try {
      // Use openBox to be safe, it will return the open box if already initialized
      final box = await Hive.openBox('settingsBox');
      _secondsAccumulated = box.get(_secondsKey, defaultValue: 0) as int;
    } catch (e) {
      _secondsAccumulated = 0;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsAccumulated++;
      
      // Save every 30 seconds to prevent data loss on crash/exit
      if (_secondsAccumulated % 30 == 0) {
        _persistSeconds();
      }

      if (_secondsAccumulated >= _hourInSeconds) {
        // Calculate how many full hours earned
        int hoursEarned = _secondsAccumulated ~/ _hourInSeconds;
        // Keep the remainder for the next "hour"
        _secondsAccumulated = _secondsAccumulated % _hourInSeconds;
        
        _persistSeconds();
        _incrementContribution(hoursEarned);
      }
    });
  }

  Future<void> _persistSeconds() async {
    try {
      final box = await Hive.openBox('settingsBox');
      await box.put(_secondsKey, _secondsAccumulated);
    } catch (e) {
      return;
    }
  }

  void stopTracking() {
    _timer?.cancel();
    _persistSeconds();
  }

  Future<void> _incrementContribution(int hours) async {
    try {
      final user = await AuthService.getUser();
      if (user != null) {
        // Send the specific number of hours earned
        await ImpactApi.incrementStat(user.id, 'contribution_hours', count: hours);
      }
    } catch (e) {
      return;
    }
  }
}

// Global instance
final contributionService = ContributionService();
