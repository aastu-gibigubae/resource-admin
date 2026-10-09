// Dashboard provider stub — implementation pending.
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardState {
  final bool isLoading;
  final String? error;
  const DashboardState({this.isLoading = false, this.error});
}

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() => const DashboardState();
}

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);
