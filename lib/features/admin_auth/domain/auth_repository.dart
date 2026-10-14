abstract class AuthRepository {
  Future<void> login({
    required String email,
    required String password,
    required String deviceFingerprint,
  });

  Future<void> logout();

  Future<void> refreshToken();
}
