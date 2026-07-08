class LearningStepModel {
  LearningStepModel({
    required this.title,
    this.isCompleted = false,
  });

  final String title;
  final bool isCompleted;

  factory LearningStepModel.fromJson(Map<String, dynamic> json) {
    return LearningStepModel(
      title: json['title']?.toString() ?? '',
      isCompleted: json['isCompleted'] is bool ? json['isCompleted'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}

class LearningModel {
  LearningModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.des,
    required this.category,
    required this.status,
    required this.priority,
    required this.startDate,
    required this.targetDate,
    this.steps = const [],
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String des;
  final String category;
  final String status;
  final String priority;
  final String startDate;
  final String targetDate;
  final List<LearningStepModel> steps;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory LearningModel.fromJson(Map<String, dynamic> json) {
    return LearningModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      des: json['des']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      targetDate: json['targetDate']?.toString() ?? '',
      steps: json['steps'] is List
          ? (json['steps'] as List)
              .map((step) => LearningStepModel.fromJson(step))
              .toList()
          : [],
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
      'des': des,
      'category': category,
      'status': status,
      'priority': priority,
      'startDate': startDate,
      'targetDate': targetDate,
      'steps': steps.map((step) => step.toJson()).toList(),
      'deletedAt': deletedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
