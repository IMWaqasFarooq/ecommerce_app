import 'dart:io';

import 'package:ecommerce_app/core/preferences/notifications_preference_notifier.dart';
import 'package:ecommerce_app/core/providers/core_providers.dart';
import 'package:ecommerce_app/core/storage/hive_boxes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;
  late Box<dynamic> box;
  late ProviderContainer container;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('notifications_pref_test');
    Hive.init(tempDir.path);
  });

  setUp(() async {
    box = await Hive.openBox<dynamic>('prefs_${DateTime.now().microsecondsSinceEpoch}');
    container = ProviderContainer(
      overrides: [
        hiveBoxesProvider.overrideWithValue({HiveBoxes.preferences: box}),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(box.deleteFromDisk);
  });

  tearDownAll(() => tempDir.deleteSync(recursive: true));

  test('defaults to enabled when nothing is stored', () {
    expect(container.read(notificationsPreferenceProvider), isTrue);
  });

  test('setEnabled(false) updates state and persists to Hive', () async {
    await container.read(notificationsPreferenceProvider.notifier).setEnabled(false);

    expect(container.read(notificationsPreferenceProvider), isFalse);
    expect(box.get(pushNotificationsPreferenceKey), false);
  });
}
