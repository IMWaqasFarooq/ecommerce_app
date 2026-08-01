import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

Future<ThemeMode?> showThemeModeSheet(BuildContext context, ThemeMode current) {
  return showModalBottomSheet<ThemeMode>(
    context: context,
    builder: (context) => _ThemeModeSheet(current: current),
  );
}

class _ThemeModeSheet extends StatelessWidget {
  const _ThemeModeSheet({required this.current});

  final ThemeMode current;

  String _label(ThemeMode mode) => switch (mode) {
    ThemeMode.system => 'System default',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };

  IconData _icon(ThemeMode mode) => switch (mode) {
    ThemeMode.system => Icons.brightness_auto_rounded,
    ThemeMode.light => Icons.light_mode_rounded,
    ThemeMode.dark => Icons.dark_mode_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              child: Text('Theme', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            for (final mode in ThemeMode.values)
              ListTile(
                leading: Icon(_icon(mode)),
                title: Text(_label(mode)),
                trailing: mode == current ? const Icon(Icons.check_rounded) : null,
                onTap: () => Navigator.of(context).pop(mode),
              ),
          ],
        ),
      ),
    );
  }
}
