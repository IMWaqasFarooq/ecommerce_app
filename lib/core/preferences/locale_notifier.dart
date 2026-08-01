import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/core_providers.dart';
import '../storage/hive_boxes.dart';

part 'locale_notifier.g.dart';

const _localeKey = 'locale';

@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    final stored = hiveBox(ref, HiveBoxes.preferences).get(_localeKey) as String?;
    return switch (stored) {
      'ar' => const Locale('ar'),
      _ => const Locale('en'),
    };
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await hiveBox(ref, HiveBoxes.preferences).put(_localeKey, locale.languageCode);
  }
}
