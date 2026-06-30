import 'package:hive/hive.dart';

part 'crop_calendar_hive_model.g.dart';

@HiveType(typeId: 10)
class CropCalendarHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String cropName;

  @HiveField(2)
  late String stage;

  @HiveField(3)
  late String recommendedDates;

  @HiveField(4)
  late String status;

  @HiveField(5)
  late String season;

  @HiveField(6)
  late String sowingPeriod;

  @HiveField(7)
  late String duration;

  @HiveField(8)
  late String harvestPeriod;

  @HiveField(9)
  late String bestSoil;

  @HiveField(10)
  late String waterRequirement;

  @HiveField(11)
  late String description;

  CropCalendarHiveModel({
    required this.id,
    required this.cropName,
    required this.stage,
    required this.recommendedDates,
    required this.status,
    required this.season,
    required this.sowingPeriod,
    required this.duration,
    required this.harvestPeriod,
    required this.bestSoil,
    required this.waterRequirement,
    required this.description,
  });
}
