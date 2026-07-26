import 'dart:io';

import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

Future<Failure> mapExceptionToFailure(Object error) async {
  return switch (error) {
    NetworkException(:final message) => Failure.network(message: message),
    UnauthorizedException(:final message) => Failure.unauthorized(message: message),
    ValidationException(:final message) => Failure.validation(message: message),
    PaymentException(:final message, :final declineCode) => Failure.payment(
      message: message,
      declineCode: declineCode,
    ),
    ServerException(:final message, :final statusCode) => Failure.server(
      message: message,
      statusCode: statusCode,
    ),
    CacheException(:final message) => Failure.cache(message: message),
    SocketException() => const Failure.network(),
    DioException() => _mapDioException(error),
    _ => Failure.unknown(message: error.toString()),
  };
}

Failure _mapDioException(DioException error) {
  if (error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout) {
    return const Failure.network();
  }
  final statusCode = error.response?.statusCode;
  if (statusCode == 401 || statusCode == 403) {
    return const Failure.unauthorized();
  }
  return Failure.server(
    message: error.response?.statusMessage ?? error.message ?? 'Server error',
    statusCode: statusCode,
  );
}
