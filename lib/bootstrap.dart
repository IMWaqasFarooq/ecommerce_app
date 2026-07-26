import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/config/env_config.dart';
import 'core/config/flavor.dart';
import 'core/providers/core_providers.dart';
import 'core/storage/hive_boxes.dart';

Future<void> bootstrap(Flavor flavor) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final env = EnvConfig(flavor);
      await env.load();

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
    (error, stackTrace) => debugPrint('Uncaught error: $error\n$stackTrace'),
  );
}
