import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'exceptions.dart';
import 'failure_code.dart';
import 'failures.dart';

Future<Failure> mapExceptionToFailure(Object error) async {
  return switch (error) {
    NetworkException(:final code) => Failure.network(code: code),
    UnauthorizedException(:final code) => Failure.unauthorized(code: code),
    ValidationException(:final code) => Failure.validation(code: code),
    PaymentException(:final code, :final declineCode) => Failure.payment(
      code: code,
      declineCode: declineCode,
    ),
    ServerException(:final code, :final statusCode) => Failure.server(
      code: code,
      statusCode: statusCode,
    ),
    CacheException(:final code) => Failure.cache(code: code),
    SocketException() => const Failure.network(),
    DioException() => _mapDioException(error),
    _ => _mapUnknown(error),
  };
}

Failure _mapUnknown(Object error) {
  debugPrint('Unhandled error mapped to Failure.unknown: $error');
  return const Failure.unknown();
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
  debugPrint('Dio error mapped to Failure.server: ${error.message}');
  return Failure.server(code: FailureCode.server, statusCode: statusCode);
}
