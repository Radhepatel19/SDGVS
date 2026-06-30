import 'package:hive/hive.dart';

part 'weather_alert_hive_model.g.dart';

@HiveType(typeId: 13)
class WeatherAlertHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String message;

  @HiveField(3)
  late String level;

  @HiveField(4)
  DateTime? expiresAt;

  WeatherAlertHiveModel({
    required this.id,
    required this.title,
    required this.message,
    required this.level,
    this.expiresAt,
  });
}
