class DashboardModel {
  DashboardModel({
    required this.totalProjects,
    required this.activeProjects,
    required this.completedTasks,
    required this.pendingTasks,
    required this.learningCount,
    this.todayFocus,
    this.recentProjects = const [],
    this.recentTasks = const [],
  });

  final int totalProjects;
  final int activeProjects;
  final int completedTasks;
  final int pendingTasks;
  final int learningCount;
  final dynamic todayFocus;
  final List<dynamic> recentProjects;
  final List<dynamic> recentTasks;

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalProjects: json['totalProjects'] is int ? json['totalProjects'] : 0,
      activeProjects: json['activeProjects'] is int ? json['activeProjects'] : 0,
      completedTasks: json['completedTasks'] is int ? json['completedTasks'] : 0,
      pendingTasks: json['pendingTasks'] is int ? json['pendingTasks'] : 0,
      learningCount: json['learningCount'] is int ? json['learningCount'] : 0,
      todayFocus: json['todayFocus'],
      recentProjects: json['recentProjects'] is List ? json['recentProjects'] : [],
      recentTasks: json['recentTasks'] is List ? json['recentTasks'] : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalProjects': totalProjects,
      'activeProjects': activeProjects,
      'completedTasks': completedTasks,
      'pendingTasks': pendingTasks,
      'learningCount': learningCount,
      'todayFocus': todayFocus,
      'recentProjects': recentProjects,
      'recentTasks': recentTasks,
    };
  }
}
