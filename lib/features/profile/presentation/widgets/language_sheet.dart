import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';

const _supportedLocales = [Locale('en'), Locale('ar')];

Future<Locale?> showLanguageSheet(BuildContext context, Locale current) {
  return showModalBottomSheet<Locale>(
    context: context,
    builder: (context) => _LanguageSheet(current: current),
  );
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet({required this.current});

  final Locale current;

  String _nativeName(Locale locale) => switch (locale.languageCode) {
    'ar' => 'العربية',
    _ => 'English',
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
                l10n.languageLabel,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            for (final locale in _supportedLocales)
              ListTile(
                title: Text(_nativeName(locale)),
                trailing: locale.languageCode == current.languageCode
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => Navigator.of(context).pop(locale),
              ),
          ],
        ),
      ),
    );
  }
}
