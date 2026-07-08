class DashboardModel {
  DashboardModel({
    required this.totalTasks,
    required this.totalNotes,
    required this.totalProjects,
    required this.totalLearnings,
    this.completedTasks = 0,
    this.completedLearnings = 0,
    this.completedProjects = 0,
    this.pinnedNotes = 0,
    this.highPriorityTasks = 0,
    this.inProgressProjects = 0,
  });

  final int totalTasks;
  final int totalNotes;
  final int totalProjects;
  final int totalLearnings;
  final int completedTasks;
  final int completedLearnings;
  final int completedProjects;
  final int pinnedNotes;
  final int highPriorityTasks;
  final int inProgressProjects;

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalTasks: json['totalTasks'] is int ? json['totalTasks'] : 0,
      totalNotes: json['totalNotes'] is int ? json['totalNotes'] : 0,
      totalProjects: json['totalProjects'] is int ? json['totalProjects'] : 0,
      totalLearnings: json['totalLearnings'] is int ? json['totalLearnings'] : 0,
      completedTasks: json['completedTasks'] is int ? json['completedTasks'] : 0,
      completedLearnings: json['completedLearnings'] is int ? json['completedLearnings'] : 0,
      completedProjects: json['completedProjects'] is int ? json['completedProjects'] : 0,
      pinnedNotes: json['pinnedNotes'] is int ? json['pinnedNotes'] : 0,
      highPriorityTasks: json['highPriorityTasks'] is int ? json['highPriorityTasks'] : 0,
      inProgressProjects: json['inProgressProjects'] is int ? json['inProgressProjects'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTasks': totalTasks,
      'totalNotes': totalNotes,
      'totalProjects': totalProjects,
      'totalLearnings': totalLearnings,
      'completedTasks': completedTasks,
      'completedLearnings': completedLearnings,
      'completedProjects': completedProjects,
      'pinnedNotes': pinnedNotes,
      'highPriorityTasks': highPriorityTasks,
      'inProgressProjects': inProgressProjects,
    };
  }
}
