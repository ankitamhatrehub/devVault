class NotesModel {
  NotesModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.category,
    this.pinned = false,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String body;
  final String category;
  final bool pinned;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      pinned: json['pinned'] is bool ? json['pinned'] : false,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'].toString()) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'category': category,
      'pinned': pinned,
      'deletedAt': deletedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
