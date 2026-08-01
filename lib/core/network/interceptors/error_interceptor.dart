import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../error/exceptions.dart';
import '../../error/failure_code.dart';

/// Normalizes Dio failures into our own Exception types.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: _mapError(err)));
  }

  Exception _mapError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(FailureCode.networkTimeout);
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badCertificate:
        return const NetworkException(FailureCode.networkInsecureConnection);
      case DioExceptionType.cancel:
        return const ServerException(FailureCode.requestCancelled);
      case DioExceptionType.badResponse:
        return _mapBadResponse(err);
      case DioExceptionType.unknown:
        if (err.error is SocketException) return const NetworkException();
        return ServerException(FailureCode.server, debugMessage: err.message);
      default:
        return ServerException(FailureCode.server, debugMessage: err.message);
    }
  }

  Exception _mapBadResponse(DioException err) {
    final statusCode = err.response?.statusCode;
    debugPrint('Bad response ($statusCode): ${_extractMessage(err.response?.data)}');

    if (statusCode == 401 || statusCode == 403) {
      return const UnauthorizedException();
    }
    if (statusCode == 429) {
      return const ServerException(FailureCode.rateLimitExceeded, statusCode: 429);
    }
    if (statusCode != null && statusCode >= 500) {
      return ServerException(FailureCode.serverUnavailable, statusCode: statusCode);
    }
    return ServerException(FailureCode.server, statusCode: statusCode);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map && data['error'] != null) return data['error'].toString();
    if (data is Map && data['message'] != null) return data['message'].toString();
    return null;
  }
}
