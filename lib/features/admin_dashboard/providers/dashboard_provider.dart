import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/dashboard_remote_datasource.dart';

export '../data/dashboard_remote_datasource.dart' show DashboardData;

class DashboardNotifier extends AsyncNotifier<DashboardData> {
  @override
  Future<DashboardData> build() {
    return ref.read(dashboardRemoteDatasourceProvider).fetchDashboard();
  }

  Future<void> resolveReport(int reportId) async {
    await ref.read(dioProvider).post<void>('/admin/reports/$reportId/resolve');
    ref.invalidateSelf();
  }

  Future<void> grantPremium(int userId, {String? note}) async {
    await ref.read(dioProvider).post<void>(
      '/admin/users/$userId/grant-premium',
      data: note != null ? {'note': note} : null,
    );
    ref.invalidateSelf();
  }
}

final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardData>(
  DashboardNotifier.new,
);
