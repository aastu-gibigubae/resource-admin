// Profile provider stub — implementation pending.
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileState {
  final bool isLoading;
  final String? error;
  const ProfileState({this.isLoading = false, this.error});
}

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileState();
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);
