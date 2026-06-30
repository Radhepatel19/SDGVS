enum NotificationType { complaint, scheme, announcement }

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    // Robustly parse the notification type, stripping class prefix if present.
    final typeStr = map['type']?.toString().toLowerCase() ?? '';
    final parsedType = NotificationType.values.firstWhere(
      (e) {
        final name = e.name.toLowerCase();
        final fullString = e.toString().toLowerCase();
        return name == typeStr ||
            fullString == typeStr ||
            fullString.endsWith('.$typeStr');
      },
      orElse: () => NotificationType.announcement,
    );

    // Support both 'created_at' from DB and 'timestamp' from offline cache/API
    final rawTime = map['created_at'] ?? map['timestamp'];
    final parsedTime = rawTime != null
        ? DateTime.tryParse(rawTime.toString()) ?? DateTime.now()
        : DateTime.now();

    return NotificationModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      type: parsedType,
      timestamp: parsedTime,
      isRead: map['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }
}
