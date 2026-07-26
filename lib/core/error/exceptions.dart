class ServerException implements Exception {
  const ServerException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);
  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Local cache error']);
  final String message;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message = 'Session expired']);
  final String message;
}

class ValidationException implements Exception {
  const ValidationException(this.message);
  final String message;
}

class PaymentException implements Exception {
  const PaymentException(this.message, {this.declineCode});
  final String message;
  final String? declineCode;
}
