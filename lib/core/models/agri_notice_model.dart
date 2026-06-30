class AgriNoticeModel {
  final String id;
  final String title;
  final String message;
  final DateTime date;

  AgriNoticeModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
    };
  }

  factory AgriNoticeModel.fromMap(Map<String, dynamic> map) {
    return AgriNoticeModel(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      date: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
    );
  }
}
