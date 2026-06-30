import 'dart:convert';

class VillageModel {
  final String id;
  final String name;
  final String taluka;
  final String district;
  final String? population;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  VillageModel({
    required this.id,
    required this.name,
    required this.taluka,
    required this.district,
    this.population,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'taluka': taluka,
      'district': district,
      'population': population,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory VillageModel.fromMap(Map<String, dynamic> map) {
    return VillageModel(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      taluka: map['taluka'] ?? '',
      district: map['district'] ?? '',
      population: map['population']?.toString(),
      status: map['status'] ?? 'active',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory VillageModel.fromJson(String source) =>
      VillageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VillageModel(id: $id, name: $name, taluka: $taluka, district: $district)';
  }
}
