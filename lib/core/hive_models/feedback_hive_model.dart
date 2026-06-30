import 'package:hive/hive.dart';

part 'feedback_hive_model.g.dart';

@HiveType(typeId: 8)
class FeedbackHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String complaintId;

  @HiveField(2)
  int rating;

  @HiveField(3)
  String comments;

  @HiveField(4)
  DateTime timestamp;

  FeedbackHiveModel({
    required this.id,
    required this.complaintId,
    required this.rating,
    required this.comments,
    required this.timestamp,
  });
}
