// Resource upload provider stub — implementation pending.
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceUploadState {
  final bool isLoading;
  final double progress;
  final String? error;
  const ResourceUploadState({
    this.isLoading = false,
    this.progress = 0.0,
    this.error,
  });
}

class ResourceUploadNotifier extends Notifier<ResourceUploadState> {
  @override
  ResourceUploadState build() => const ResourceUploadState();
}

final resourceUploadProvider =
    NotifierProvider<ResourceUploadNotifier, ResourceUploadState>(
  ResourceUploadNotifier.new,
);
