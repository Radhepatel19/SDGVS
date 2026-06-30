enum NoticeType { general, water, power }

class NoticeModel {
  final String id;
  final String title;
  final String message;
  final NoticeType type;
  final int? priorityOrder;
  final DateTime date;

  NoticeModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    this.priorityOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'date': date.toIso8601String(),
      'priority_order': priorityOrder,
    };
  }

  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: NoticeType.values.firstWhere(
        (e) => e.name == (map['type'] ?? 'general'),
        orElse: () => NoticeType.general,
      ),
      date: map['date'] != null 
          ? DateTime.parse(map['date']) 
          : (map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now()),
      priorityOrder: map['priority_order'] ?? map['priorityOrder'],
    );
  }
}
