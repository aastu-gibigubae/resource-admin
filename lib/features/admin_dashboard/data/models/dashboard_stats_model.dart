class DashboardStatsModel {
  final int totalUsers;
  final int pendingReports;
  final int totalResources;
  final int activePremium;

  const DashboardStatsModel({
    required this.totalUsers,
    required this.pendingReports,
    required this.totalResources,
    required this.activePremium,
  });

  factory DashboardStatsModel.fromMock() => const DashboardStatsModel(
        totalUsers: 128,
        pendingReports: 0,
        totalResources: 0,
        activePremium: 47,
      );
}
