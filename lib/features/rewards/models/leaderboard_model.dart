import 'reward_winner.dart';

class LeaderboardEntry {
  final String userId;
  final String userName;
  final int rank;
  final int points;
  final RewardCategory category;
  final String? profileImageUrl;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.rank,
    required this.points,
    required this.category,
    this.profileImageUrl,
  });

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    RewardCategory mappedCategory = RewardCategory.helpfulCitizen;
    final String occ = (map['occupation'] ?? '').toString().toLowerCase();
    
    if (occ.contains('student')) {
      mappedCategory = RewardCategory.topStudent;
    } else if (occ.contains('farmer')) {
      mappedCategory = RewardCategory.bestFarmer;
    }

    return LeaderboardEntry(
      userId: (map['userId'] ?? map['user_id'] ?? '').toString(),
      userName: map['userName'] ?? map['user_name'] ?? 'Unknown User',
      rank: map['rank'] ?? 0,
      points: map['points'] ?? map['community_impact_score'] ?? 0,
      category: mappedCategory,
      profileImageUrl: map['profileImageUrl'] ?? map['profile_image_url'],
    );
  }
}

class LeaderboardData {
  final List<LeaderboardEntry> entries;
  final RewardCategory category;
  final String month;
  final String year;

  LeaderboardData({
    required this.entries,
    required this.category,
    required this.month,
    required this.year,
  });
}
