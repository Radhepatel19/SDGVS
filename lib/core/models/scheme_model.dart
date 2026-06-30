class SchemeModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final List<String> objectives;
  final List<String> eligibility;
  final List<String> benefits;
  final List<String> documentsRequired;
  final String url;

  SchemeModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.objectives,
    required this.eligibility,
    required this.benefits,
    required this.documentsRequired,
    this.url = '',
  });

  factory SchemeModel.fromMap(Map<String, dynamic> map) {
    List<String> toList(dynamic value) {
      if (value == null) return [];
      if (value is List) return List<String>.from(value.map((e) => e.toString()));
      if (value is String) {
        // Handle PG array string format "{item1,item2}" if necessary
        if (value.startsWith('{') && value.endsWith('}')) {
          return value
              .substring(1, value.length - 1)
              .split(',')
              .map((e) => e.trim().replaceAll('"', ''))
              .toList();
        }
        return [value];
      }
      return [];
    }

    return SchemeModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      objectives: toList(map['objectives']),
      eligibility: toList(map['eligibility']),
      benefits: toList(map['benefits']),
      documentsRequired: toList(map['documents_required'] ?? map['documentsRequired'] ?? map['docs_required']),
      url: map['url'] ?? '',
    );
  }
}
