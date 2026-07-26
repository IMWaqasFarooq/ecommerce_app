import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/signup_page.dart';
import '../../features/authentication/presentation/pages/splash_page.dart';
import '../../features/authentication/presentation/providers/auth_state_provider.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/products/presentation/pages/product_list_page.dart';
import '../../features/profile/presentation/pages/profile_placeholder_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/wishlist/presentation/pages/wishlist_page.dart';
import 'main_shell.dart';
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
        path: RoutePaths.search,
        name: RouteNames.search,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: RoutePaths.productDetail,
        name: RouteNames.productDetail,
        builder: (context, state) => ProductDetailPage(
          productId: int.parse(state.pathParameters['productId']!),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                name: RouteNames.home,
                builder: (context, state) => const ProductListPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.wishlist,
                name: RouteNames.wishlist,
                builder: (context, state) => const WishlistPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.cart,
                name: RouteNames.cart,
                builder: (context, state) => const CartPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                name: RouteNames.profile,
                builder: (context, state) => const ProfilePlaceholderPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
