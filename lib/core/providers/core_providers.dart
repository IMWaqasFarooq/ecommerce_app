import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../config/env_config.dart';
import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/network_info.dart';
import '../storage/secure_storage.dart';

// Overridden in bootstrap() with the flavor's loaded config.
final envConfigProvider = Provider<EnvConfig>((ref) {
  throw UnimplementedError('envConfigProvider must be overridden in bootstrap()');
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorageImpl(const FlutterSecureStorage());
});

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.watch(connectivityProvider));
});

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(ref.watch(firebaseAuthProvider));
});

final dioProvider = Provider<Dio>((ref) {
  return DioClient.create(
    env: ref.watch(envConfigProvider),
    authInterceptor: ref.watch(authInterceptorProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

/// Overridden in bootstrap() once every feature box has been opened.
final hiveBoxesProvider = Provider<Map<String, Box<dynamic>>>((ref) {
  throw UnimplementedError('hiveBoxesProvider must be overridden in bootstrap()');
});

Box<dynamic> hiveBox(Ref ref, String name) => ref.watch(hiveBoxesProvider)[name]!;
