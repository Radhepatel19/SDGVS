class DocumentModel {
  final String id;
  final String title;
  final String type;
  final DateTime uploadDate;
  final String? filePath;

  DocumentModel({
    required this.id,
    required this.title,
    required this.type,
    required this.uploadDate,
    required this.filePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'uploadDate': uploadDate.toIso8601String(),
      'filePath': filePath,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    // Support both DB snake_case keys and Hive camelCase keys
    final rawDate = map['upload_date'] ?? map['uploadDate'];
    final parsedDate = rawDate != null
        ? DateTime.tryParse(rawDate.toString()) ?? DateTime.now()
        : DateTime.now();

    return DocumentModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      uploadDate: parsedDate,
      filePath: map['file_path'] ?? map['filePath'],
    );
  }
}
