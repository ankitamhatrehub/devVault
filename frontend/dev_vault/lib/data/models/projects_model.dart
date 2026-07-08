class ProjectsModel {
  ProjectsModel({
    required this.id,
    required this.userId,
    required this.projectName,
    required this.summary,
    required this.primaryStack,
    required this.status,
    required this.deadline,
    required this.teamSize,
    required this.projectNotes,
    this.focusTags = const [],
    this.progress = 0,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String projectName;
  final String summary;
  final String primaryStack;
  final String status;
  final String deadline;
  final String teamSize;
  final String projectNotes;
  final List<String> focusTags;
  final int progress;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ProjectsModel.fromJson(Map<String, dynamic> json) {
    return ProjectsModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      projectName: json['projectName']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      primaryStack: json['primaryStack']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      deadline: json['deadline']?.toString() ?? '',
      teamSize: json['teamSize']?.toString() ?? '',
      projectNotes: json['projectNotes']?.toString() ?? '',
      focusTags: json['focusTags'] is List ? List<String>.from(json['focusTags']) : [],
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
      'projectName': projectName,
      'summary': summary,
      'primaryStack': primaryStack,
      'status': status,
      'deadline': deadline,
      'teamSize': teamSize,
      'projectNotes': projectNotes,
      'focusTags': focusTags,
      'progress': progress,
      'deletedAt': deletedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
