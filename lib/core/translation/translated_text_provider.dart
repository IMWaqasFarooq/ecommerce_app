import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../preferences/locale_notifier.dart';
import '../providers/core_providers.dart';
import '../storage/hive_boxes.dart';
import 'translation_service.dart';

part 'translated_text_provider.g.dart';

@riverpod
Future<String> translatedText(Ref ref, String text) async {
  final locale = ref.watch(localeProvider);
  if (locale.languageCode == 'en' || text.trim().isEmpty) return text;

  final box = hiveBox(ref, HiveBoxes.translations);
  final cacheKey = '${locale.languageCode}:$text';
  final cached = box.get(cacheKey) as String?;
  if (cached != null) return cached;

  final translated = await translateWithFallback(
    ref.read(translationServiceProvider),
    text,
    to: locale.languageCode,
  );
  await box.put(cacheKey, translated);
  return translated;
}
