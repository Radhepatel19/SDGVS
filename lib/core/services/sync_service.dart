import 'dart:async';
import 'connectivity_service.dart';
import 'hive_service.dart';
import '../apis/complaint_api.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  final StreamController<bool> _syncStatusController =
      StreamController<bool>.broadcast();
  Stream<bool> get syncStatusStream => _syncStatusController.stream;

  /// Sync all offline pending complaints to the remote server database.
  Future<Map<String, dynamic>> syncOfflineData() async {
    if (_isSyncing) {
      return {'success': false, 'message': 'Sync already in progress.'};
    }

    final online = ConnectivityService().isOnline;
    if (!online) {
      return {'success': false, 'message': 'No internet connection. Cannot sync.'};
    }

    _isSyncing = true;
    _syncStatusController.add(_isSyncing);

    try {
      final pendingComplaints = HiveService.getPendingSyncComplaints();
      if (pendingComplaints.isEmpty) {
        _isSyncing = false;
        _syncStatusController.add(_isSyncing);
        return {'success': true, 'message': 'Everything is up to date.', 'count': 0};
      }

      int successCount = 0;
      int failCount = 0;

      for (final pc in pendingComplaints) {
        final originalId = pc.id;
        final result = await ComplaintApi.createComplaint(pc);
        if (result['success'] == true) {
          // Delete original temporary local complaint
          await HiveService.deleteComplaint(originalId);
          successCount++;
        } else {
          failCount++;
        }
      }

      _isSyncing = false;
      _syncStatusController.add(_isSyncing);

      if (failCount > 0) {
        return {
          'success': false,
          'message': 'Synced $successCount complaints successfully. $failCount failed.',
          'count': successCount
        };
      }

      return {
        'success': true,
        'message': 'Successfully synced all $successCount pending complaints!',
        'count': successCount
      };
    } catch (e) {
      _isSyncing = false;
      _syncStatusController.add(_isSyncing);
      return {'success': false, 'message': 'An error occurred during sync: $e'};
    }
  }

  void dispose() {
    _syncStatusController.close();
  }
}
