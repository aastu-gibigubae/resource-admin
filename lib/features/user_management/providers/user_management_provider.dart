import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/user_model.dart';

class UserManagementNotifier extends AsyncNotifier<List<UserModel>> {
  String _filter = 'All';

  @override
  Future<List<UserModel>> build() async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get<dynamic>('/admin/users');
      final data = response.data;
      List<dynamic> list = [];
      if (data is Map) {
        list = data['users'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? [];
      } else if (data is List) {
        list = data;
      }
      return list.isEmpty
          ? UserModel.mockList()
          : list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return UserModel.mockList();
    }
  }

  String get filter => _filter;

  void setFilter(String f) {
    _filter = f;
    ref.invalidateSelf();
  }

  Future<void> resetDevice(int userId) async {
    try {
      await ref.read(dioProvider).post<void>('/admin/users/$userId/revoke-device');
    } catch (_) {}
    ref.invalidateSelf();
  }
}

final userManagementProvider =
    AsyncNotifierProvider<UserManagementNotifier, List<UserModel>>(
  UserManagementNotifier.new,
);
