import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/analytics/analytics_auth_observer.dart';
import 'core/config/flavor.dart';
import 'core/preferences/theme_mode_notifier.dart';
import 'core/router/app_router.dart';
import 'core/sync/guest_data_sync_observer.dart';
import 'core/theme/app_theme.dart';

class VeloraApp extends ConsumerWidget {
  const VeloraApp({super.key, required this.flavor});

  final Flavor flavor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(guestDataSyncObserverProvider);
    ref.watch(analyticsAuthObserverProvider);
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Velora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
