import 'package:hive/hive.dart';

part 'poll_hive_model.g.dart';

@HiveType(typeId: 4)
class PollOptionHiveModel extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  int votes;

  @HiveField(2)
  String id;

  PollOptionHiveModel({required this.text, this.votes = 0, this.id = ''});
}

@HiveType(typeId: 5)
class PollHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String question;

  @HiveField(2)
  List<PollOptionHiveModel> options;

  @HiveField(3)
  int totalVotes;

  @HiveField(4)
  DateTime expiryDate;

  @HiveField(5)
  int? userVotedOptionIndex;

  PollHiveModel({
    required this.id,
    required this.question,
    required this.options,
    required this.totalVotes,
    required this.expiryDate,
    this.userVotedOptionIndex,
  });
}
