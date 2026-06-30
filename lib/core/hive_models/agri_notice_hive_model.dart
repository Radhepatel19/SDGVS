import 'package:hive/hive.dart';

part 'agri_notice_hive_model.g.dart';

@HiveType(typeId: 14) // Unique typeId
class AgriNoticeHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String message;

  @HiveField(3)
  late DateTime date;

  AgriNoticeHiveModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
  });
}
