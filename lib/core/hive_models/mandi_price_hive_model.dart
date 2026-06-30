import 'package:hive/hive.dart';

part 'mandi_price_hive_model.g.dart';

@HiveType(typeId: 11)
class MandiPriceHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String cropName;

  @HiveField(2)
  late String price;

  @HiveField(3)
  late String change;

  @HiveField(4)
  late String mandi;

  @HiveField(5)
  late String minPrice;

  @HiveField(6)
  late String maxPrice;

  @HiveField(7)
  late String unit;

  @HiveField(8)
  late String status;

  @HiveField(9)
  late DateTime date;

  MandiPriceHiveModel({
    required this.id,
    required this.cropName,
    required this.price,
    required this.change,
    required this.mandi,
    required this.minPrice,
    required this.maxPrice,
    required this.unit,
    required this.status,
    required this.date,
  });
}
