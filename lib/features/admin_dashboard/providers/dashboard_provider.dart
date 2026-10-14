import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dashboard_remote_datasource.dart';

export '../data/dashboard_remote_datasource.dart' show DashboardData;

class DashboardNotifier extends AsyncNotifier<DashboardData> {
  @override
  Future<DashboardData> build() {
    return ref.read(dashboardRemoteDatasourceProvider).fetchDashboard();
  }

  Future<void> approveRequest(int id) async {
    await ref.read(dashboardRemoteDatasourceProvider).approveRequest(id);
    ref.invalidateSelf();
  }

  Future<void> rejectRequest(int id) async {
    await ref.read(dashboardRemoteDatasourceProvider).rejectRequest(id);
    ref.invalidateSelf();
  }
}

final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardData>(
  DashboardNotifier.new,
);
