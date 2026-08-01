import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/preferences/notifications_preference_notifier.dart';
import '../../../../core/preferences/theme_mode_notifier.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../authentication/presentation/providers/auth_controller_provider.dart';
import '../../../authentication/presentation/providers/auth_state_provider.dart';
import '../widgets/edit_profile_sheet.dart';
import '../widgets/theme_mode_sheet.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final themeMode = ref.watch(themeModeProvider);
    final notificationsEnabled = ref.watch(notificationsPreferenceProvider);
    final displayName = user?.displayName ?? 'Unknown';
    final email = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(radius: 32, child: Text(displayName[0].toUpperCase())),
                const SizedBox(height: AppSpacing.sm),
                Text(displayName, style: Theme.of(context).textTheme.titleMedium),
                if (email.isNotEmpty)
                  Text(email, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: AppSpacing.xs),
                TextButton.icon(
                  onPressed: () => showEditProfileSheet(context, currentName: displayName),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('My orders'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(RoutePaths.orders),
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('My addresses'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(RoutePaths.addresses),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_outline_rounded),
            title: const Text('Wishlist'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(RoutePaths.wishlist),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionHeader('Preferences'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme'),
            trailing: Text(
              switch (themeMode) {
                ThemeMode.system => 'System',
                ThemeMode.light => 'Light',
                ThemeMode.dark => 'Dark',
              },
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () async {
              final mode = await showThemeModeSheet(context, themeMode);
              if (mode != null) {
                await ref.read(themeModeProvider.notifier).setThemeMode(mode);
              }
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Push notifications'),
            value: notificationsEnabled,
            onChanged: (value) =>
                ref.read(notificationsPreferenceProvider.notifier).setEnabled(value),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionHeader('Support'),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('About'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(RoutePaths.about),
          ),
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton.icon(
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
