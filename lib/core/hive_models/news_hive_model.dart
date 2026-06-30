import 'package:hive/hive.dart';

part 'news_hive_model.g.dart';

@HiveType(typeId: 20)
class NewsHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  int categoryIndex;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String? imageUrl;

  @HiveField(6)
  String author;

  @HiveField(7)
  int likes;

  @HiveField(8)
  bool? userLiked;

  NewsHiveModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryIndex,
    required this.date,
    this.imageUrl,
    required this.author,
    this.likes = 0,
    this.userLiked = false,
  });
}
