import 'failure_code.dart';

class ServerException implements Exception {
  const ServerException(this.code, {this.statusCode, this.debugMessage});
  final FailureCode code;
  final int? statusCode;
  final String? debugMessage;
}

class NetworkException implements Exception {
  const NetworkException([this.code = FailureCode.network]);
  final FailureCode code;
}

class CacheException implements Exception {
  const CacheException([this.code = FailureCode.cache]);
  final FailureCode code;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.code = FailureCode.sessionExpired, this.debugMessage]);
  final FailureCode code;
  final String? debugMessage;
}

class ValidationException implements Exception {
  const ValidationException(this.code);
  final FailureCode code;
}

class PaymentException implements Exception {
  const PaymentException(this.code, {this.declineCode});
  final FailureCode code;
  final String? declineCode;
}
