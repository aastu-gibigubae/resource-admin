class DashboardStatsModel {
  final int totalStudents;
  final int activeSubscriptions;
  final int resourceUploaded;

  const DashboardStatsModel({
    required this.totalStudents,
    required this.activeSubscriptions,
    required this.resourceUploaded,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalStudents: json['total_students'] as int? ??
          json['total_users'] as int? ?? 0,
      activeSubscriptions: json['active_subscriptions'] as int? ??
          json['active_premium'] as int? ?? 0,
      resourceUploaded: json['resource_uploaded'] as int? ??
          json['total_resources'] as int? ?? 0,
    );
  }

  static DashboardStatsModel mock() => const DashboardStatsModel(
        totalStudents: 194,
        activeSubscriptions: 128,
        resourceUploaded: 450,
      );
}
