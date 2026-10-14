import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../domain/auth_user.dart';

abstract class AuthRemoteDatasource {
  Future<AuthUser> login({
    required String email,
    required String password,
    required String deviceFingerprint,
  });

  Future<void> logout();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;
  final SecureStorageService _storage;

  const AuthRemoteDatasourceImpl(this._dio, this._storage);

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
    required String deviceFingerprint,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
          'device_fingerprint': deviceFingerprint,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final accessToken = data['access_token'] as String;
      final refreshToken = data['refresh_token'] as String;

      await _storage.saveAccessToken(accessToken);
      await _storage.saveRefreshToken(refreshToken);

      final userMap = data['user'] as Map<String, dynamic>;
      return AuthUser.fromJson(userMap);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Invalid email or password.');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      }
      final statusCode = e.response?.statusCode ?? 0;
      final message = _extractMessage(e.response?.data) ?? e.message ?? 'Server error';
      throw ServerException(statusCode: statusCode, message: message);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(ApiConstants.logout);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      }
      // Swallow other logout errors — clear storage regardless
    }
    await _storage.clearAll();
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String?;
    }
    return null;
  }
}

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasourceImpl>((ref) {
  return AuthRemoteDatasourceImpl(
    ref.read(dioProvider),
    ref.read(secureStorageProvider),
  );
});
