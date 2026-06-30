import 'dart:convert';

class UserModel {
  final String id;
  final String? name;
  final String? district;
  final String? taluka;
  final String? village;
  final String mobile;
  final bool isRegistered;
  final bool isVerified;
  final String? profileImage;
  final String? email;
  final String? gender;
  final DateTime? dob;
  final String? address;
  final String? occupation;
  final String? villageId;
  final String status;
  final DateTime? lastLogin;

  UserModel({
    required this.id,
    this.name,
    this.district,
    this.taluka,
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
    this.villageId,
    this.status = 'active',
    this.lastLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'district': district,
      'taluka': taluka,
      'village_name': village,
      'village_id': villageId,
      'mobile': mobile,
      'is_registered': isRegistered,
      'is_verified': isVerified,
      'profile_image_url': profileImage,
      'email': email,
      'gender': gender,
      'dob': dob?.toIso8601String(),
      'address': address,
      'occupation': occupation,
      'status': status,
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? map['full_name'],
      district: map['district'],
      taluka: map['taluka'],
      village: map['village_name'] ?? map['village'],
      mobile: map['mobile'] ?? '',
      isRegistered: map['is_registered'] ?? map['isRegistered'] ?? false,
      isVerified: map['is_verified'] ?? map['isVerified'] ?? false,
      profileImage: map['profile_image_url'] ?? map['profileImage'],
      email: map['email'],
      gender: map['gender'],
      dob: map['dob'] != null ? DateTime.tryParse(map['dob'].toString()) : null,
      address: map['address'],
      occupation: map['occupation'],
      villageId: map['village_id']?.toString() ?? map['villageId']?.toString(),
      status: map['status'] ?? 'active',
      lastLogin: map['last_login'] != null
          ? DateTime.tryParse(map['last_login'].toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? id,
    String? name,
    String? district,
    String? taluka,
    String? village,
    String? mobile,
    bool? isRegistered,
    bool? isVerified,
    String? profileImage,
    String? email,
    String? gender,
    DateTime? dob,
    String? address,
    String? occupation,
    String? villageId,
    String? status,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      district: district ?? this.district,
      taluka: taluka ?? this.taluka,
      village: village ?? this.village,
      mobile: mobile ?? this.mobile,
      isRegistered: isRegistered ?? this.isRegistered,
      isVerified: isVerified ?? this.isVerified,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      occupation: occupation ?? this.occupation,
      villageId: villageId ?? this.villageId,
      status: status ?? this.status,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
