import 'dart:convert';

class AdminModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? villageId;
  final String? address;
  final bool isFirstLogin;
  final String status;

  AdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.villageId,
    this.address,
    this.isFirstLogin = true,
    this.status = 'active',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'villageId': villageId,
      'address': address,
      'isFirstLogin': isFirstLogin,
      'status': status,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'village_admin',
      villageId: map['village_id']?.toString() ?? map['villageId']?.toString(),
      address: map['address'],
      isFirstLogin: map['is_first_login'] ?? map['isFirstLogin'] ?? true,
      status: map['status'] ?? 'active',
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminModel.fromJson(String source) =>
      AdminModel.fromMap(json.decode(source));
}
