import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';

Dio createDioClient(Ref ref) {
  final secureStorage = ref.read(secureStorageProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  dio.interceptors.add(
    AuthInterceptor(
      getAccessToken: secureStorage.getAccessToken,
      getRefreshToken: secureStorage.getRefreshToken,
      saveAccessToken: secureStorage.saveAccessToken,
      onLogout: secureStorage.clearAll,
    ),
  );

  return dio;
}

final dioProvider = Provider<Dio>((ref) => createDioClient(ref));
