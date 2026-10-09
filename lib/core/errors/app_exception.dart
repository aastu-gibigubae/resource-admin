/// Custom exception hierarchy for the Resource Admin app.
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

final class ServerException extends AppException {
  final int statusCode;
  const ServerException({required this.statusCode, required String message})
      : super(message);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized. Please log in again.']);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

final class ValidationException extends AppException {
  final Map<String, String> fieldErrors;
  const ValidationException({
    String message = 'Validation failed',
    this.fieldErrors = const {},
  }) : super(message);
}

final class UnknownException extends AppException {
  const UnknownException([super.message = 'An unexpected error occurred']);
}
