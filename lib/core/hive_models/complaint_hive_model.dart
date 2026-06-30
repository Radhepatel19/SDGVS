import 'package:hive/hive.dart';

part 'complaint_hive_model.g.dart';

@HiveType(typeId: 1)
class ComplaintHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String category;

  @HiveField(2)
  String description;

  @HiveField(3)
  String? imagePath;

  @HiveField(4)
  String? voicePath;

  @HiveField(5)
  DateTime timestamp;

  @HiveField(6)
  String status;

  @HiveField(7)
  String? adminRemarks;

  /// Whether this complaint is pending sync to the server.
  @HiveField(8)
  bool pendingSync;

  ComplaintHiveModel({
    required this.id,
    required this.category,
    required this.description,
    this.imagePath,
    this.voicePath,
    required this.timestamp,
    this.status = 'Pending',
    this.adminRemarks,
    this.pendingSync = true,
  });
}
