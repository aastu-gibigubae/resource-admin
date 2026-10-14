import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../admin_dashboard/data/models/pending_report_model.dart';

class PendingRequestsNotifier
    extends AsyncNotifier<List<PendingReportModel>> {
  @override
  Future<List<PendingReportModel>> build() => _fetchPage(1);

  Future<List<PendingReportModel>> _fetchPage(int page) async {
    final dio = ref.read(dioProvider);
    final response = await dio.get<Map<String, dynamic>>(
      '/admin/reports',
      queryParameters: {
        'status': 'pending',
        'limit': 20,
        'page': page,
      },
    );
    final data = response.data!;
    final reports = data['reports'] as List<dynamic>;
    return PendingReportModel.listFromJson(reports);
  }

  Future<void> resolveReport(int id) async {
    final dio = ref.read(dioProvider);
    await dio.post<void>('/admin/reports/$id/resolve');
    ref.invalidateSelf();
    await future;
  }
}

final pendingRequestsProvider =
    AsyncNotifierProvider<PendingRequestsNotifier, List<PendingReportModel>>(
  PendingRequestsNotifier.new,
);
