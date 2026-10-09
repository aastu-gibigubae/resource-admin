// Global admin session provider stub.
// Will be implemented when auth feature is completed.
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SessionStatus { unknown, authenticated, unauthenticated }

class SessionState {
  final SessionStatus status;
  final String? accessToken;
  const SessionState({this.status = SessionStatus.unknown, this.accessToken});
}

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() => const SessionState();

  void setAuthenticated(String token) {
    state = SessionState(status: SessionStatus.authenticated, accessToken: token);
  }

  void setUnauthenticated() {
    state = const SessionState(status: SessionStatus.unauthenticated);
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(
  SessionNotifier.new,
);
