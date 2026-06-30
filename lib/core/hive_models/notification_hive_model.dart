import 'package:hive/hive.dart';

part 'notification_hive_model.g.dart';

@HiveType(typeId: 7)
class NotificationHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String message;

  /// Stored as int: 0=complaint, 1=scheme, 2=announcement
  @HiveField(3)
  int typeIndex;

  @HiveField(4)
  DateTime timestamp;

  @HiveField(5)
  bool isRead;

  NotificationHiveModel({
    required this.id,
    required this.title,
    required this.message,
    required this.typeIndex,
    required this.timestamp,
    this.isRead = false,
  });
}
