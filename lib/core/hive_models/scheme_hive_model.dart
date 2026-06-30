import 'package:hive/hive.dart';

part 'scheme_hive_model.g.dart';

@HiveType(typeId: 3)
class SchemeHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String category;

  @HiveField(3)
  String description;

  @HiveField(4)
  List<String> objectives;

  @HiveField(5)
  List<String> eligibility;

  @HiveField(6)
  List<String> benefits;

  @HiveField(7)
  List<String> documentsRequired;

  SchemeHiveModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.objectives,
    required this.eligibility,
    required this.benefits,
    required this.documentsRequired,
  });
}
