import 'dart:convert';

class UserImpactStats {
  final String userId;
  final int complaintsResolved;
  final int schemesApplied;
  final int contributionHours;
  final int communityImpactScore;
  final DateTime updatedAt;
  final List<ImpactBadge> badges;

  UserImpactStats({
    required this.userId,
    this.complaintsResolved = 0,
    this.schemesApplied = 0,
    this.contributionHours = 0,
    this.communityImpactScore = 0,
    required this.updatedAt,
    this.badges = const [],
  });

  factory UserImpactStats.fromMap(Map<String, dynamic> map) {
    return UserImpactStats(
      userId: map['user_id']?.toString() ?? '',
      complaintsResolved: map['complaintsResolved'] ?? map['complaints_resolved'] ?? 0,
      schemesApplied: map['schemesApplied'] ?? map['schemes_applied'] ?? 0,
      contributionHours: map['contributionHours'] ?? map['contribution_hours'] ?? 0,
      communityImpactScore: map['communityImpactScore'] ?? map['community_impact_score'] ?? 0,
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at']) 
          : DateTime.now(),
      badges: (map['badges'] as List? ?? [])
          .map((b) => ImpactBadge.fromMap(b))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'complaints_resolved': complaintsResolved,
      'schemes_applied': schemesApplied,
      'contribution_hours': contributionHours,
      'community_impact_score': communityImpactScore,
      'updated_at': updatedAt.toIso8601String(),
      'badges': badges.map((b) => b.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory UserImpactStats.fromJson(String source) =>
      UserImpactStats.fromMap(json.decode(source));
}

class ImpactBadge {
  final String name;
  final String description;
  final DateTime dateEarned;
  final String? adminId;

  ImpactBadge({
    required this.name,
    required this.description,
    required this.dateEarned,
    this.adminId,
  });

  factory ImpactBadge.fromMap(Map<String, dynamic> map) {
    return ImpactBadge(
      name: map['name'] ?? 'Badge',
      description: map['description'] ?? '',
      dateEarned: map['date_earned'] != null 
          ? DateTime.parse(map['date_earned']) 
          : (map['dateEarned'] != null ? DateTime.parse(map['dateEarned']) : DateTime.now()),
      adminId: map['admin_id']?.toString() ?? map['adminId']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'date_earned': dateEarned.toIso8601String(),
      'admin_id': adminId,
    };
  }
}

class RewardWinnerModel {
  final String id;
  final String userId;
  final String name;
  final String? villageName;
  final String category;
  final String month;
  final int year;
  final String? profileImage;
  final String achievement;

  RewardWinnerModel({
    required this.id,
    required this.userId,
    required this.name,
    this.villageName,
    required this.category,
    required this.month,
    required this.year,
    this.profileImage,
    required this.achievement,
  });

  factory RewardWinnerModel.fromMap(Map<String, dynamic> map) {
    return RewardWinnerModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      name: map['name'] ?? '',
      villageName: map['village_name'],
      category: map['category'] ?? '',
      month: map['month'] ?? '',
      year: map['year'] ?? DateTime.now().year,
      profileImage: map['profile_image_url'],
      achievement: map['achievement'] ?? '',
    );
  }
}
