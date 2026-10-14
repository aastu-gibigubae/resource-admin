import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/dio_client.dart';
import 'models/dashboard_stats_model.dart';
import 'models/pending_request_model.dart';
import 'models/recent_activity_model.dart';

class DashboardData {
  final DashboardStatsModel stats;
  final List<PendingRequestModel> pendingRequests;
  final List<RecentActivityModel> recentActivity;

  const DashboardData({
    required this.stats,
    required this.pendingRequests,
    required this.recentActivity,
  });
}

class DashboardRemoteDatasource {
  final Dio _dio;

  const DashboardRemoteDatasource(this._dio);

  Future<DashboardData> fetchDashboard() async {
    try {
      final results = await Future.wait([
        _dio.get<dynamic>('/admin/reports',
            queryParameters: {'status': 'pending', 'limit': 5, 'page': 1}),
        _dio.get<dynamic>('/admin/resources',
            queryParameters: {'limit': 1, 'page': 1}),
      ]);

      final reportsData = results[0].data;
      final resourcesData = results[1].data;

      // Parse pending requests
      List<PendingRequestModel> pendingRequests = [];
      int totalStudents = 194;
      int activeSubscriptions = 128;
      int totalResources = 0;

      if (reportsData is Map) {
        final list = reportsData['reports'] as List<dynamic>? ??
            reportsData['data'] as List<dynamic>? ?? [];
        pendingRequests = list
            .map((e) => PendingRequestModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final pagination = reportsData['pagination'] as Map? ?? {};
        totalStudents = (pagination['total'] as int?) ?? 194;
      } else if (reportsData is List) {
        pendingRequests = reportsData
            .map((e) => PendingRequestModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (resourcesData is Map) {
        final pagination = resourcesData['pagination'] as Map? ?? {};
        totalResources = (pagination['total'] as int?) ?? 450;
      }

      return DashboardData(
        stats: DashboardStatsModel(
          totalStudents: totalStudents,
          activeSubscriptions: activeSubscriptions,
          resourceUploaded: totalResources,
        ),
        pendingRequests: pendingRequests.isNotEmpty
            ? pendingRequests
            : PendingRequestModel.mockList(),
        recentActivity: RecentActivityModel.mockList(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw const UnauthorizedException();
      return _mockData();
    } catch (_) {
      return _mockData();
    }
  }

  Future<void> approveRequest(int id) async {
    await _dio.post<void>('/admin/reports/$id/resolve',
        data: {'action': 'approve'});
  }

  Future<void> rejectRequest(int id) async {
    await _dio.post<void>('/admin/reports/$id/resolve',
        data: {'action': 'reject'});
  }

  DashboardData _mockData() => DashboardData(
        stats: DashboardStatsModel.mock(),
        pendingRequests: PendingRequestModel.mockList(),
        recentActivity: RecentActivityModel.mockList(),
      );
}

final dashboardRemoteDatasourceProvider =
    Provider<DashboardRemoteDatasource>((ref) {
  return DashboardRemoteDatasource(ref.read(dioProvider));
});
