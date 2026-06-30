import 'package:hive/hive.dart';

part 'document_hive_model.g.dart';

@HiveType(typeId: 6)
class DocumentHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String type;

  @HiveField(3)
  DateTime uploadDate;

  @HiveField(4)
  String? filePath;

  DocumentHiveModel({
    required this.id,
    required this.title,
    required this.type,
    required this.uploadDate,
    required this.filePath,
  });
}
