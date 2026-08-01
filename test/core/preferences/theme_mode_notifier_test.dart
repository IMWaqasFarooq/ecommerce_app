import 'dart:io';

import 'package:ecommerce_app/core/preferences/theme_mode_notifier.dart';
import 'package:ecommerce_app/core/providers/core_providers.dart';
import 'package:ecommerce_app/core/storage/hive_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;
  late Box<dynamic> box;
  late ProviderContainer container;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('theme_mode_test');
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

  test('defaults to system when nothing is stored', () {
    expect(container.read(themeModeProvider), ThemeMode.system);
  });

  test('setThemeMode updates state and persists to Hive', () async {
    await container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);

    expect(container.read(themeModeProvider), ThemeMode.dark);
    expect(box.get('theme_mode'), 'dark');
  });

  test('a fresh notifier reads back a previously persisted value', () async {
    await box.put('theme_mode', 'light');

    final freshContainer = ProviderContainer(
      overrides: [
        hiveBoxesProvider.overrideWithValue({HiveBoxes.preferences: box}),
      ],
    );
    addTearDown(freshContainer.dispose);

    expect(freshContainer.read(themeModeProvider), ThemeMode.light);
  });
}
