import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/providers/cart_notifier.dart';
import '../../features/wishlist/presentation/providers/wishlist_notifier.dart';

class MainShell extends ConsumerWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartProvider).value?.itemCount ?? 0;
    final wishlistCount = ref.watch(wishlistProvider).value?.length ?? 0;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) =>
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: _BadgedIcon(count: wishlistCount, icon: Icons.favorite_outline_rounded),
            selectedIcon: _BadgedIcon(count: wishlistCount, icon: Icons.favorite_rounded),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: _BadgedIcon(count: cartCount, icon: Icons.shopping_bag_outlined),
            selectedIcon: _BadgedIcon(count: cartCount, icon: Icons.shopping_bag_rounded),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
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
