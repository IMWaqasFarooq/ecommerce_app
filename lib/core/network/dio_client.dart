import 'package:dio/dio.dart';

import '../config/env_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'network_info.dart';

class DioClient {
  static Dio create({
    required EnvConfig env,
    required AuthInterceptor authInterceptor,
    required NetworkInfo networkInfo,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: env.apiBaseUrl,
        connectTimeout: env.connectTimeout,
        receiveTimeout: env.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      authInterceptor,
      RetryInterceptor(
        dio: dio,
        networkInfo: networkInfo,
        maxRetries: env.maxRetries,
        baseDelay: env.retryBaseDelay,
      ),
      ErrorInterceptor(),
      if (env.enableNetworkLogging) LoggingInterceptor(),
    ]);

    return dio;
  }
}
