import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/flavor.dart';

Future<void> bootstrap(Flavor flavor) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(ProviderScope(child: VeloraApp(flavor: flavor)));
    },
    (error, stackTrace) => debugPrint('Uncaught error: $error\n$stackTrace'),
  );
}
