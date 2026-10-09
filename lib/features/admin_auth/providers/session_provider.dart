// Admin auth session provider stub — implementation pending.
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthSessionState {
  final bool isAuthenticated;
  final String? token;
  const AuthSessionState({this.isAuthenticated = false, this.token});
}

class AuthSessionNotifier extends Notifier<AuthSessionState> {
  @override
  AuthSessionState build() => const AuthSessionState();
}

final authSessionProvider = NotifierProvider<AuthSessionNotifier, AuthSessionState>(
  AuthSessionNotifier.new,
);
