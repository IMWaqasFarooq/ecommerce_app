import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/core_providers.dart';
import '../storage/hive_boxes.dart';

part 'theme_mode_notifier.g.dart';

const _themeModeKey = 'theme_mode';

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    final stored = hiveBox(ref, HiveBoxes.preferences).get(_themeModeKey) as String?;
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await hiveBox(ref, HiveBoxes.preferences).put(_themeModeKey, mode.name);
  }
}
