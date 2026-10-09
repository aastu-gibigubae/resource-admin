// Forgot password provider stub — implementation pending.
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordState {
  final bool isLoading;
  final String? error;
  const ForgotPasswordState({this.isLoading = false, this.error});
}

class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
  @override
  ForgotPasswordState build() => const ForgotPasswordState();
}

final forgotPasswordProvider =
    NotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
  ForgotPasswordNotifier.new,
);
