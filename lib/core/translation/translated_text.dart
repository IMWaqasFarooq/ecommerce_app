import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../preferences/locale_notifier.dart';
import 'translated_text_provider.dart';

/// Displays [text] as-is in English, or translates it (with Hive-backed
/// caching) when the app locale isn't English. Shows the source text
/// immediately and swaps in the translation once it resolves, falling
/// back to the source text if translation fails.
class TranslatedText extends ConsumerWidget {
  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final display = locale.languageCode == 'en'
        ? text
        : ref.watch(translatedTextProvider(text)).value ?? text;

    return Text(display, style: style, maxLines: maxLines, overflow: overflow, textAlign: textAlign);
  }
}
