import 'package:flutter/material.dart';

enum NewsCategory {
  successStory,
  newDevelopment,
  scholarshipWinner,
  govtBenefit,
  villageAchievement,
}

class NewsModel {
  final String id;
  final String title;
  final String description;
  final NewsCategory category;
  final DateTime date;
  final String? imageUrl;
  final String author;
  final int likes;
  final bool userLiked;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.imageUrl,
    required this.author,
    this.likes = 0,
    this.userLiked = false,
  });

  String get categoryName {
    switch (category) {
      case NewsCategory.successStory:
        return 'Success Story';
      case NewsCategory.newDevelopment:
        return 'New Development';
      case NewsCategory.scholarshipWinner:
        return 'Scholarship Winner';
      case NewsCategory.govtBenefit:
        return 'Govt Benefit Received';
      case NewsCategory.villageAchievement:
        return 'Village Achievement';
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case NewsCategory.successStory:
        return Icons.star_rounded;
      case NewsCategory.newDevelopment:
        return Icons.build_rounded;
      case NewsCategory.scholarshipWinner:
        return Icons.school_rounded;
      case NewsCategory.govtBenefit:
        return Icons.account_balance_rounded;
      case NewsCategory.villageAchievement:
        return Icons.emoji_events_rounded;
    }
  }

  Color get categoryColor {
    switch (category) {
      case NewsCategory.successStory:
        return const Color(0xFF6C5CE7);
      case NewsCategory.newDevelopment:
        return const Color(0xFF20BF6B);
      case NewsCategory.scholarshipWinner:
        return const Color(0xFFFD9644);
      case NewsCategory.govtBenefit:
        return const Color(0xFF45AAF2);
      case NewsCategory.villageAchievement:
        return const Color(0xFFFFD700);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'author': author,
      'likes': likes,
      'user_liked': userLiked,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    // Graceful degraded matching for categories from DB
    NewsCategory mappedCategory = NewsCategory.successStory;
    final String dbCategory = (map['category'] ?? '').toString().toLowerCase();
    
    if (dbCategory.contains('development')) {
      mappedCategory = NewsCategory.newDevelopment;
    } else if (dbCategory.contains('scholarship') || dbCategory.contains('education')) {
      mappedCategory = NewsCategory.scholarshipWinner;
    } else if (dbCategory.contains('benefit') || dbCategory.contains('agriculture')) {
      mappedCategory = NewsCategory.govtBenefit;
    } else if (dbCategory.contains('achievement')) {
      mappedCategory = NewsCategory.villageAchievement;
    }

    return NewsModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: mappedCategory,
      date: map['date'] != null 
          ? DateTime.parse(map['date']) 
          : (map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now()),
      imageUrl: map['imageUrl'] ?? map['image_url'],
      author: map['author'] ?? 'Unknown',
      likes: map['likes'] ?? 0,
      userLiked: map['user_liked'] == true,
    );
  }

  NewsModel copyWith({
    String? id,
    String? title,
    String? description,
    NewsCategory? category,
    DateTime? date,
    String? imageUrl,
    String? author,
    int? likes,
    bool? userLiked,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      likes: likes ?? this.likes,
      userLiked: userLiked ?? this.userLiked,
    );
  }
}

// Keep GoodNewsItem as an alias for backward compatibility if needed,
// though we will update the screens.
typedef GoodNewsItem = NewsModel;
typedef GoodNewsModel = NewsModel;
