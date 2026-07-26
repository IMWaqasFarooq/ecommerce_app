import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/authentication/presentation/pages/home_placeholder_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/signup_page.dart';
import '../../features/authentication/presentation/pages/splash_page.dart';
import '../../features/authentication/presentation/providers/auth_state_provider.dart';
import 'route_paths.dart';

part 'app_router.g.dart';

// Notifies go_router on auth changes without GoRouter itself depending on (and rebuilding from) that state.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authStateProvider, (previous, next) => notifyListeners());
  }
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final atSplash = state.matchedLocation == RoutePaths.splash;
      final atLogin = state.matchedLocation == RoutePaths.login;
      final atSignup = state.matchedLocation == RoutePaths.signup;

      if (authState.isLoading) return atSplash ? null : RoutePaths.splash;

      final isAuthenticated = authState.value != null;
      if (isAuthenticated) {
        return (atSplash || atLogin || atSignup) ? RoutePaths.home : null;
      }
      return (atLogin || atSignup) ? null : RoutePaths.login;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.signup,
        name: RouteNames.signup,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePlaceholderPage(),
      ),
    ],
  );
}
