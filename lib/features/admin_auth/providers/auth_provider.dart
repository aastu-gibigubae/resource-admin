import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers/session_provider.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/auth_remote_datasource.dart';
import '../domain/auth_user.dart';

export '../domain/auth_user.dart';

// ---------------------------------------------------------------------------
// AuthState
// ---------------------------------------------------------------------------

class AuthState {
  final bool isLoading;
  final String? error;
  final AuthUser? user;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    AuthUser? user,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      user: clearUser ? null : (user ?? this.user),
    );
  }
}

// ---------------------------------------------------------------------------
// AuthNotifier
// ---------------------------------------------------------------------------

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final datasource = ref.read(authRemoteDatasourceProvider);
      final user = await datasource.login(
        email: email,
        password: password,
        deviceFingerprint: 'admin-panel-v1',
      );

      final token = await ref.read(secureStorageProvider).getAccessToken();
      ref.read(sessionProvider.notifier).setAuthenticated(token ?? '');

      state = state.copyWith(isLoading: false, user: user, clearError: true);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final datasource = ref.read(authRemoteDatasourceProvider);
      await datasource.logout();
    } catch (_) {
      // Clear session even if network logout fails
    }
    ref.read(sessionProvider.notifier).setUnauthenticated();
    state = const AuthState();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
