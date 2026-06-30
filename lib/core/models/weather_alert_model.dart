class WeatherAlertModel {
  final String id;
  final String title;
  final String message;
  final String level; // info, warning, critical
  final DateTime? expiresAt;

  WeatherAlertModel({
    required this.id,
    required this.title,
    required this.message,
    required this.level,
    this.expiresAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'level': level,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  factory WeatherAlertModel.fromMap(Map<String, dynamic> map) {
    return WeatherAlertModel(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      level: map['alert_level'] ?? map['level'] ?? 'info',
      expiresAt: map['expires_at'] != null ? DateTime.parse(map['expires_at']) : null,
    );
  }
}
