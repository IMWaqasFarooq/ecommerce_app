import 'package:ecommerce_app/app.dart';
import 'package:ecommerce_app/core/config/env_config.dart';
import 'package:ecommerce_app/core/config/flavor.dart';
import 'package:ecommerce_app/core/providers/core_providers.dart';
import 'package:ecommerce_app/core/storage/hive_boxes.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int maxTries = 30,
  Duration step = const Duration(seconds: 1),
}) async {
  for (var i = 0; i < maxTries; i++) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) return;
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'sign up with email/password creates a real Firebase account, then signs out',
    (tester) async {
      final env = EnvConfig(Flavor.development);
      await env.load();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            envConfigProvider.overrideWithValue(env),
            hiveBoxesProvider.overrideWithValue(boxes),
          ],
          child: const VeloraApp(flavor: Flavor.development),
        ),
      );

      await _pumpUntilFound(tester, find.text('Welcome back'));
      await tester.tap(find.text('Sign up'));
      await _pumpUntilFound(tester, find.text('Create account'));

      final email = 'test_${DateTime.now().microsecondsSinceEpoch}@velora-test.dev';
      await tester.enterText(find.widgetWithText(TextFormField, 'Full name'), 'Test User');
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), email);
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.tap(find.widgetWithText(FilledButton, 'Create account'));

      await _pumpUntilFound(tester, find.text('Velora'), maxTries: 40);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      // displayName lands via a second userChanges() emission after the sign-in redirect already fired.
      await _pumpUntilFound(tester, find.textContaining('Test User'), maxTries: 15);
      expect(find.textContaining('Test User'), findsOneWidget);

      await tester.tap(find.text('Log out'));
      await _pumpUntilFound(tester, find.text('Welcome back'));
      expect(find.text('Welcome back'), findsOneWidget);
    },
  );
}
