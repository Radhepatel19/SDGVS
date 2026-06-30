import 'package:hive/hive.dart';

part 'notice_hive_model.g.dart';

@HiveType(typeId: 2)
class NoticeHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String message;

  /// Stored as int: 0=general, 1=water, 2=power
  @HiveField(3)
  int typeIndex;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  bool isHighPriority;

  NoticeHiveModel({
    required this.id,
    required this.title,
    required this.message,
    required this.typeIndex,
    required this.date,
    this.isHighPriority = false,
  });
}
