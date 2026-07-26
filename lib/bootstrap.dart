import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/config/env_config.dart';
import 'core/config/flavor.dart';
import 'core/notifications/push_notification_service.dart';
import 'core/providers/core_providers.dart';
import 'core/remote_config/remote_config_service.dart';
import 'core/storage/hive_boxes.dart';
import 'firebase_options.dart';

Future<void> bootstrap(Flavor flavor) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stackTrace) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
        return true;
      };

      final env = EnvConfig(flavor);
      await env.load();

      Stripe.publishableKey = env.stripePublishableKey;
      await Stripe.instance.applySettings();

      await RemoteConfigServiceImpl(FirebaseRemoteConfig.instance).initialize();
      await PushNotificationServiceImpl().initialize();

      await Hive.initFlutter();
      final boxes = {
        for (final name in [
          HiveBoxes.products,
          HiveBoxes.cart,
          HiveBoxes.wishlist,
          HiveBoxes.searchHistory,
          HiveBoxes.preferences,
          HiveBoxes.orders,
        ])
          name: await Hive.openBox<dynamic>(name),
      };

      runApp(
        ProviderScope(
          overrides: [
            envConfigProvider.overrideWithValue(env),
            hiveBoxesProvider.overrideWithValue(boxes),
          ],
          child: VeloraApp(flavor: flavor),
        ),
      );
    },
    (error, stackTrace) {
      debugPrint('Uncaught error: $error\n$stackTrace');
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    },
  );
}
