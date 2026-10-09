// User management provider stub — implementation pending.
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserManagementState {
  final bool isLoading;
  final String? error;
  const UserManagementState({this.isLoading = false, this.error});
}

class UserManagementNotifier extends Notifier<UserManagementState> {
  @override
  UserManagementState build() => const UserManagementState();
}

final userManagementProvider =
    NotifierProvider<UserManagementNotifier, UserManagementState>(
  UserManagementNotifier.new,
);
