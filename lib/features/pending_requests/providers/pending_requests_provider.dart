import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../admin_dashboard/data/models/pending_request_model.dart';

class PendingRequestsNotifier
    extends AsyncNotifier<List<PendingRequestModel>> {
  @override
  Future<List<PendingRequestModel>> build() async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get<dynamic>(
        '/admin/reports',
        queryParameters: {'status': 'pending', 'limit': 20, 'page': 1},
      );
      final data = response.data;
      List<dynamic> list = [];
      if (data is Map) {
        list = data['reports'] as List<dynamic>? ??
            data['data'] as List<dynamic>? ?? [];
      } else if (data is List) {
        list = data;
      }
      final parsed = list
          .map((e) => PendingRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return parsed.isNotEmpty ? parsed : PendingRequestModel.mockList();
    } catch (_) {
      return PendingRequestModel.mockList();
    }
  }

  Future<void> approveRequest(int id) async {
    try {
      await ref.read(dioProvider).post<void>(
        '/admin/reports/$id/resolve',
        data: {'action': 'approve'},
      );
    } catch (_) {}
    ref.invalidateSelf();
  }

  Future<void> rejectRequest(int id) async {
    try {
      await ref.read(dioProvider).post<void>(
        '/admin/reports/$id/resolve',
        data: {'action': 'reject'},
      );
    } catch (_) {}
    ref.invalidateSelf();
  }
}

final pendingRequestsProvider =
    AsyncNotifierProvider<PendingRequestsNotifier, List<PendingRequestModel>>(
  PendingRequestsNotifier.new,
);
