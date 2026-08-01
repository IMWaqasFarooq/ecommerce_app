import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutLabel)),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final info = snapshot.data;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Center(
                child: Column(
                  children: [
                    Icon(Icons.storefront_rounded, size: 56, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Velora', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      info == null ? ' ' : l10n.versionLabel(info.version, info.buildNumber),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('Velora'),
                subtitle: Text(l10n.aboutAppDescription),
              ),
            ],
          );
        },
      ),
    );
  }
}
