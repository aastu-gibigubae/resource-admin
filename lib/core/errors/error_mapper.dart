// Maps Dio/backend errors to AppException types.
import 'package:dio/dio.dart';
import 'app_exception.dart';

class ErrorMapper {
  ErrorMapper._();

  static AppException fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final data = e.response?.data;
        final message = _extractMessage(data);
        if (statusCode == 401) return const UnauthorizedException();
        if (statusCode == 404) return NotFoundException(message);
        if (statusCode == 422) {
          final fieldErrors = _extractFieldErrors(data);
          return ValidationException(message: message, fieldErrors: fieldErrors);
        }
        return ServerException(statusCode: statusCode, message: message);
      default:
        return const UnknownException();
    }
  }

  static String _extractMessage(dynamic data) {
    if (data is Map) return data['message']?.toString() ?? 'Server error';
    return 'Server error';
  }

  static Map<String, String> _extractFieldErrors(dynamic data) {
    if (data is Map && data['errors'] is Map) {
      return (data['errors'] as Map).map(
        (k, v) => MapEntry(k.toString(), v.toString()),
      );
    }
    return {};
  }
}
