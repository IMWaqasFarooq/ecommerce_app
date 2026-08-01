import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/providers/cart_notifier.dart';
import '../../features/wishlist/presentation/providers/wishlist_notifier.dart';
import '../../l10n/generated/app_localizations.dart';

class MainShell extends ConsumerWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cartCount = ref.watch(cartProvider).value?.itemCount ?? 0;
    final wishlistCount = ref.watch(wishlistProvider).value?.length ?? 0;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) =>
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.storefront_outlined),
            selectedIcon: const Icon(Icons.storefront_rounded),
            label: l10n.navShop,
          ),
          NavigationDestination(
            icon: _BadgedIcon(count: wishlistCount, icon: Icons.favorite_outline_rounded),
            selectedIcon: _BadgedIcon(count: wishlistCount, icon: Icons.favorite_rounded),
            label: l10n.wishlist,
          ),
          NavigationDestination(
            icon: _BadgedIcon(count: cartCount, icon: Icons.shopping_bag_outlined),
            selectedIcon: _BadgedIcon(count: cartCount, icon: Icons.shopping_bag_rounded),
            label: l10n.cartTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.profileTitle,
          ),
        ],
      ),
    );
  }
}

class _BadgedIcon extends StatelessWidget {
  const _BadgedIcon({required this.count, required this.icon});

  final int count;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return Icon(icon);
    return Badge(label: Text('$count'), child: Icon(icon));
  }
}
