import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/app_spacing.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
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
                      info == null ? ' ' : 'Version ${info.version} (${info.buildNumber})',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.info_outline_rounded),
                title: Text('Velora'),
                subtitle: Text(
                  'A portfolio e-commerce app built with Flutter, Riverpod, Firebase, and Stripe.',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
