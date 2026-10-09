// JWT attach + refresh interceptor stub.
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getAccessToken;
  final Future<String?> Function() getRefreshToken;
  final Future<void> Function(String token) saveAccessToken;
  final Future<void> Function() onLogout;

  AuthInterceptor({
    required this.getAccessToken,
    required this.getRefreshToken,
    required this.saveAccessToken,
    required this.onLogout,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // TODO: implement token refresh logic
      await onLogout();
    }
    handler.next(err);
  }
}
