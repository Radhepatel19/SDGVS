import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'sync_service.dart';

/// Service to detect and react to online/offline connectivity changes.
class ConnectivityService {
  static final ConnectivityService _instance =
      ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();

  bool _isOnline = true;

  /// Initialize the service and start listening for changes.
  Future<void> init() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = _isConnected(result);
    if (_isOnline) {
      SyncService().syncOfflineData();
    }

    _connectivity.onConnectivityChanged.listen((results) {
      final online = _isConnected(results);
      if (online != _isOnline) {
        _isOnline = online;
        _controller.add(_isOnline);
        if (_isOnline) {
          SyncService().syncOfflineData();
        }
      }
    });
  }

  /// Whether the device is currently online.
  bool get isOnline => _isOnline;

  /// Whether the device is currently offline.
  bool get isOffline => !_isOnline;

  /// Stream that emits `true` when online, `false` when offline.
  Stream<bool> get connectivityStream => _controller.stream;

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet,
    );
  }

  void dispose() {
    _controller.close();
  }
}
