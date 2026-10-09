// Device management provider stub — implementation pending.
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceManagementState {
  final bool isLoading;
  final String? error;
  const DeviceManagementState({this.isLoading = false, this.error});
}

class DeviceManagementNotifier extends Notifier<DeviceManagementState> {
  @override
  DeviceManagementState build() => const DeviceManagementState();
}

final deviceManagementProvider =
    NotifierProvider<DeviceManagementNotifier, DeviceManagementState>(
  DeviceManagementNotifier.new,
);
