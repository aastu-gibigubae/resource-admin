import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/dio_client.dart';
import 'models/dashboard_stats_model.dart';
import 'models/pending_report_model.dart';
import 'models/recent_activity_model.dart';

class DashboardData {
  final DashboardStatsModel stats;
  final List<PendingReportModel> pendingReports;
  final List<RecentActivityModel> recentActivity;

  const DashboardData({
    required this.stats,
    required this.pendingReports,
    required this.recentActivity,
  });
}

class DashboardRemoteDatasource {
  final Dio _dio;

  const DashboardRemoteDatasource(this._dio);

  Future<DashboardData> fetchDashboard() async {
    try {
      final results = await Future.wait([
        _dio.get<Map<String, dynamic>>(
          '/admin/reports',
          queryParameters: {'status': 'pending', 'limit': 5, 'page': 1},
        ),
        _dio.get<Map<String, dynamic>>(
          '/admin/resources',
          queryParameters: {'limit': 1, 'page': 1},
        ),
      ]);

      final reportsResponse = results[0].data!;
      final resourcesResponse = results[1].data!;

      final reportsList = reportsResponse['reports'] as List<dynamic>? ?? [];
      final reportsPagination =
          reportsResponse['pagination'] as Map<String, dynamic>? ?? {};
      final totalPendingReports =
          (reportsPagination['total'] as int?) ?? reportsList.length;

      final resourcesPagination =
          resourcesResponse['pagination'] as Map<String, dynamic>? ?? {};
      final totalResources = (resourcesPagination['total'] as int?) ?? 0;

      final pendingReports = PendingReportModel.listFromJson(reportsList);

      final stats = DashboardStatsModel(
        totalUsers: 128,
        pendingReports: totalPendingReports,
        totalResources: totalResources,
        activePremium: 47,
      );

      return DashboardData(
        stats: stats,
        pendingReports: pendingReports,
        recentActivity: RecentActivityModel.mockList(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      // On any other error, return mock data
      return DashboardData(
        stats: DashboardStatsModel.fromMock(),
        pendingReports: [],
        recentActivity: RecentActivityModel.mockList(),
      );
    } catch (_) {
      // On any unexpected error, return mock data
      return DashboardData(
        stats: DashboardStatsModel.fromMock(),
        pendingReports: [],
        recentActivity: RecentActivityModel.mockList(),
      );
    }
  }
}

final dashboardRemoteDatasourceProvider =
    Provider<DashboardRemoteDatasource>((ref) {
  return DashboardRemoteDatasource(ref.read(dioProvider));
});
