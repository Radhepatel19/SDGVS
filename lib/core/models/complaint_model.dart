class ComplaintModel {
  final String id;
  final String? complaintIdDisplay; // e.g. "SDGVS-2025-1234" from backend
  final String category;
  final String description;
  final String? priority;   // 'low', 'medium', 'high'
  final String? imagePath;  // local path (before upload)
  final String? imageUrl;   // remote URL (after upload / from backend)
  final String? voicePath;  // local path
  final String? audioUrl;   // remote URL
  final DateTime timestamp;
  final String status;       // UI values: 'Pending', 'In Progress', 'Resolved'
  final String? adminRemarks;
  final String? userId;

  ComplaintModel({
    required this.id,
    this.complaintIdDisplay,
    required this.category,
    required this.description,
    this.priority = 'medium',
    this.imagePath,
    this.imageUrl,
    this.voicePath,
    this.audioUrl,
    required this.timestamp,
    this.status = 'Pending',
    this.adminRemarks,
    this.userId,
  });

  // ──────────────────────────────────────────────
  // Map for sending to backend
  // ──────────────────────────────────────────────
  Map<String, dynamic> toApiMap() {
    return {
      'user_id':              userId,
      'complaint_id_display': complaintIdDisplay,
      'category':             category,
      'description':          description,
      'priority':             priority,
      'image_url':            imageUrl ?? imagePath,
      'audio_url':            audioUrl ?? voicePath,
    };
  }

  // ──────────────────────────────────────────────
  // Map for Hive local cache
  // ──────────────────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id':                  id,
      'complaintIdDisplay':  complaintIdDisplay,
      'category':            category,
      'description':         description,
      'priority':            priority,
      'imagePath':           imagePath,
      'imageUrl':            imageUrl,
      'voicePath':           voicePath,
      'audioUrl':            audioUrl,
      'timestamp':           timestamp.toIso8601String(),
      'status':              status,
      'adminRemarks':        adminRemarks,
      'userId':              userId,
    };
  }

  // ──────────────────────────────────────────────
  // Parse backend response (snake_case fields)
  // ──────────────────────────────────────────────
  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    // Schema stores status as: 'Pending', 'In Progress', 'Resolved' — use directly
    final status = map['status'] ?? 'Pending';

    return ComplaintModel(
      id:                 map['id']?.toString() ?? '',
      complaintIdDisplay: map['complaint_id_display'] ?? map['complaintIdDisplay'],
      category:           map['category'] ?? '',
      description:        map['description'] ?? '',
      priority:           map['priority'] ?? 'medium',
      imagePath:          map['imagePath'],
      imageUrl:           map['image_url'] ?? map['imageUrl'],
      voicePath:          map['voicePath'],
      audioUrl:           map['audio_url'] ?? map['audioUrl'],
      timestamp:          map['created_at'] != null
                            ? DateTime.parse(map['created_at'].toString())
                            : map['timestamp'] != null
                              ? DateTime.parse(map['timestamp'].toString())
                              : DateTime.now(),
      status:             status,
      adminRemarks:       map['admin_remarks'] ?? map['adminRemarks'],
      userId:             map['user_id']?.toString() ?? map['userId']?.toString(),
    );
  }
}
