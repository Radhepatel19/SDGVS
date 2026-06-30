class AgriResourceModel {
  final String id;
  final String resourceName;
  final String availabilityPercent; // e.g. "75%" — formatted for display
  final String statusColor;         // 'green', 'orange', 'red'

  AgriResourceModel({
    required this.id,
    required this.resourceName,
    required this.availabilityPercent,
    required this.statusColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'resourceName': resourceName,
      'availabilityPercent': availabilityPercent,
      'statusColor': statusColor,
    };
  }

  factory AgriResourceModel.fromMap(Map<String, dynamic> map) {
    // Backend sends availability_percentage as an integer (0-100)
    final rawPercent = map['availability_percentage'] ?? map['availabilityPercent'];
    final percentNum = (rawPercent is num) ? rawPercent.toInt() : int.tryParse(rawPercent?.toString() ?? '0') ?? 0;
    final percentStr = '$percentNum%';

    // Derive color from the number if not explicitly provided
    final rawColor = map['status_color'] ?? map['statusColor'];
    final String statusColor = rawColor != null
        ? rawColor.toString()
        : percentNum >= 60
            ? 'green'
            : percentNum >= 30
                ? 'orange'
                : 'red';

    return AgriResourceModel(
      id: map['id'].toString(),
      resourceName: map['resource_name'] ?? map['resourceName'] ?? '',
      availabilityPercent: percentStr,
      statusColor: statusColor,
    );
  }
}
