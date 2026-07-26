import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../authentication/presentation/providers/auth_controller_provider.dart';
import '../../../authentication/presentation/providers/auth_state_provider.dart';

class ProfilePlaceholderPage extends ConsumerWidget {
  const ProfilePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  child: Text((user?.displayName ?? user?.email ?? '?')[0].toUpperCase()),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(user?.displayName ?? user?.email ?? 'Unknown'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('My orders'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(RoutePaths.orders),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}
