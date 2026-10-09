// Pending requests provider stub — implementation pending.
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingRequestsState {
  final bool isLoading;
  final String? error;
  const PendingRequestsState({this.isLoading = false, this.error});
}

class PendingRequestsNotifier extends Notifier<PendingRequestsState> {
  @override
  PendingRequestsState build() => const PendingRequestsState();
}

final pendingRequestsProvider =
    NotifierProvider<PendingRequestsNotifier, PendingRequestsState>(
  PendingRequestsNotifier.new,
);
