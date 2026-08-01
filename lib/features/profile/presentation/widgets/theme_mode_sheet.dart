import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';

Future<ThemeMode?> showThemeModeSheet(BuildContext context, ThemeMode current) {
  return showModalBottomSheet<ThemeMode>(
    context: context,
    builder: (context) => _ThemeModeSheet(current: current),
  );
}

class _ThemeModeSheet extends StatelessWidget {
  const _ThemeModeSheet({required this.current});

  final ThemeMode current;

  String _label(AppLocalizations l10n, ThemeMode mode) => switch (mode) {
    ThemeMode.system => l10n.themeSystemDefault,
    ThemeMode.light => l10n.themeLight,
    ThemeMode.dark => l10n.themeDark,
  };

  IconData _icon(ThemeMode mode) => switch (mode) {
    ThemeMode.system => Icons.brightness_auto_rounded,
    ThemeMode.light => Icons.light_mode_rounded,
    ThemeMode.dark => Icons.dark_mode_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              child: Text(
                l10n.themeLabel,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            for (final mode in ThemeMode.values)
              ListTile(
                leading: Icon(_icon(mode)),
                title: Text(_label(l10n, mode)),
                trailing: mode == current ? const Icon(Icons.check_rounded) : null,
                onTap: () => Navigator.of(context).pop(mode),
              ),
          ],
        ),
      ),
    );
  }
}
