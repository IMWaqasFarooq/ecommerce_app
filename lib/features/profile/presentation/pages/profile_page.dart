import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/preferences/locale_notifier.dart';
import '../../../../core/preferences/notifications_preference_notifier.dart';
import '../../../../core/preferences/theme_mode_notifier.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../authentication/presentation/providers/auth_controller_provider.dart';
import '../../../authentication/presentation/providers/auth_state_provider.dart';
import '../widgets/edit_profile_sheet.dart';
import '../widgets/language_sheet.dart';
import '../widgets/theme_mode_sheet.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authStateProvider).value;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final notificationsEnabled = ref.watch(notificationsPreferenceProvider);
    final displayName = user?.displayName ?? l10n.unknownUser;
    final email = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
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
                  label: Text(l10n.editProfile),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(l10n.accountSection),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text(l10n.myOrders),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(RoutePaths.orders),
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(l10n.myAddresses),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(RoutePaths.addresses),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_outline_rounded),
            title: Text(l10n.wishlist),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(RoutePaths.wishlist),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionHeader(l10n.preferencesSection),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.themeLabel),
            trailing: Text(
              switch (themeMode) {
                ThemeMode.system => l10n.themeSystem,
                ThemeMode.light => l10n.themeLight,
                ThemeMode.dark => l10n.themeDark,
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
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(l10n.languageLabel),
            trailing: Text(
              locale.languageCode == 'ar' ? 'العربية' : 'English',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () async {
              final selected = await showLanguageSheet(context, locale);
              if (selected != null) {
                await ref.read(localeProvider.notifier).setLocale(selected);
              }
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text(l10n.pushNotifications),
            value: notificationsEnabled,
            onChanged: (value) =>
                ref.read(notificationsPreferenceProvider.notifier).setEnabled(value),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionHeader(l10n.supportSection),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: Text(l10n.aboutLabel),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(RoutePaths.about),
          ),
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton.icon(
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout_rounded),
            label: Text(l10n.logOut),
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
