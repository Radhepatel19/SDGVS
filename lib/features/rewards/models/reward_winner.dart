import 'package:flutter/material.dart';

enum RewardCategory {
  helpfulCitizen,
  topStudent,
  bestFarmer,
}

class RewardWinner {
  final String id;
  final String userId;
  final String? adminId;
  final String name;
  final String village;
  final RewardCategory category;
  final String year;
  final String? certificateUrl;
  final String achievement;
  final DateTime dateAwarded;

  RewardWinner({
    required this.id,
    required this.userId,
    this.adminId,
    required this.name,
    required this.village,
    required this.category,
    required this.year,
    this.certificateUrl,
    required this.achievement,
    required this.dateAwarded,
  });

  factory RewardWinner.fromMap(Map<String, dynamic> map) {
    RewardCategory mappedCategory = RewardCategory.helpfulCitizen;
    final String dbCategory = (map['category'] ?? '').toString().toLowerCase();

    if (dbCategory.contains('student')) {
      mappedCategory = RewardCategory.topStudent;
    } else if (dbCategory.contains('farmer')) {
      mappedCategory = RewardCategory.bestFarmer;
    } else if (dbCategory.contains('citizen')) {
      mappedCategory = RewardCategory.helpfulCitizen;
    }

    return RewardWinner(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? map['userId']?.toString() ?? '',
      adminId: map['admin_id']?.toString() ?? map['adminId']?.toString(),
      name: map['name'] ?? '',
      village: map['village'] ?? map['village_name'] ?? '',
      category: mappedCategory,
      year: map['year']?.toString() ?? '',
      certificateUrl: map['certificate_url'] ?? map['certificateUrl'],
      achievement: map['achievement'] ?? '',
      dateAwarded: map['date_awarded'] != null
          ? DateTime.parse(map['date_awarded'].toString())
          : (map['dateAwarded'] != null ? DateTime.parse(map['dateAwarded'].toString()) : DateTime.now()),
    );
  }

  String get categoryName {
    switch (category) {
      case RewardCategory.helpfulCitizen:
        return 'Citizen';
      case RewardCategory.topStudent:
        return 'Student';
      case RewardCategory.bestFarmer:
        return 'Farmer';
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case RewardCategory.helpfulCitizen:
        return Icons.volunteer_activism_rounded;
      case RewardCategory.topStudent:
        return Icons.school_rounded;
      case RewardCategory.bestFarmer:
        return Icons.agriculture_rounded;
    }
  }

  Color get categoryColor {
    switch (category) {
      case RewardCategory.helpfulCitizen:
        return const Color(0xFF6C5CE7);
      case RewardCategory.topStudent:
        return const Color(0xFFFD9644);
      case RewardCategory.bestFarmer:
        return const Color(0xFF20BF6B);
    }
  }
}
