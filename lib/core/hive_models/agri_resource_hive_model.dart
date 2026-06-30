import 'package:hive/hive.dart';

part 'agri_resource_hive_model.g.dart';

@HiveType(typeId: 12)
class AgriResourceHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String resourceName;

  @HiveField(2)
  late String availabilityPercent;

  @HiveField(3)
  late String statusColor;

  AgriResourceHiveModel({
    required this.id,
    required this.resourceName,
    required this.availabilityPercent,
    required this.statusColor,
  });
}
