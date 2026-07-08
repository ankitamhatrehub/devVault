class TasksModel {
  TasksModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.category,
    this.progress = 0,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String description;
  final String priority;
  final String status;
  final String dueDate;
  final String category;
  final int progress;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory TasksModel.fromJson(Map<String, dynamic> json) {
    return TasksModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      dueDate: json['dueDate']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      progress: json['progress'] is int ? json['progress'] : 0,
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
      'description': description,
      'priority': priority,
      'status': status,
      'dueDate': dueDate,
      'category': category,
      'progress': progress,
      'deletedAt': deletedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
