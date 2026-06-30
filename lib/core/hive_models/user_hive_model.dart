import 'package:hive/hive.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(14)
  String? id;

  @HiveField(1)
  String? village;

  @HiveField(2)
  String mobile;

  @HiveField(4)
  bool isRegistered;

  @HiveField(5)
  bool isVerified;

  @HiveField(6)
  String? profileImage;

  @HiveField(7)
  String? email;

  @HiveField(8)
  String? gender;

  @HiveField(9)
  DateTime? dob;

  @HiveField(10)
  String? address;

  @HiveField(11)
  String? occupation;

  @HiveField(12)
  String? district;

  @HiveField(13)
  String? taluka;

  @HiveField(15)
  String? villageId;

  @HiveField(16)
  String status;

  @HiveField(17)
  DateTime? lastLogin;

  UserHiveModel({
    this.id,
    this.name,
    this.village,
    required this.mobile,
    this.isRegistered = false,
    this.isVerified = false,
    this.profileImage,
    this.email,
    this.gender,
    this.dob,
    this.address,
    this.occupation,
    this.district,
    this.taluka,
    this.villageId,
    this.status = 'active',
    this.lastLogin,
  });
}
