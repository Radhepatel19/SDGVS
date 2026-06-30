class FeedbackModel {
  final String id;
  final String userId;
  final String complaintId;
  final int rating;
  final String comments;
  final DateTime timestamp;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.complaintId,
    required this.rating,
    required this.comments,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'complaint_id': complaintId,
      'rating': rating,
      'comments': comments,
      'created_at': timestamp.toIso8601String(),
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? map['userId']?.toString() ?? '',
      complaintId: map['complaint_id']?.toString() ?? map['complaintId']?.toString() ?? '',
      rating: map['rating'] ?? 0,
      comments: map['comments'] ?? '',
      timestamp: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : (map['timestamp'] != null ? DateTime.parse(map['timestamp']) : DateTime.now()),
    );
  }
}
