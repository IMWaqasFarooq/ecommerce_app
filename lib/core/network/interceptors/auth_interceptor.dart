import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Attaches a fresh Firebase ID token; Firebase handles refresh internally,
/// so this never reads from static storage. Opt out via extra['requiresAuth'] = false.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final requiresAuth = options.extra['requiresAuth'] as bool? ?? true;
    if (requiresAuth) {
      final token = await _firebaseAuth.currentUser?.getIdToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
