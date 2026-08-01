import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

const _easternArabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

String _localeTag(BuildContext context) => Localizations.localeOf(context).toString();

/// intl's NumberFormat/DateFormat only localize separators and symbols for
/// Arabic — they don't substitute Eastern Arabic-Indic digits. Do that
/// substitution ourselves as a post-processing pass.
String localizeDigits(BuildContext context, String text) {
  if (Localizations.localeOf(context).languageCode != 'ar') return text;
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    if (rune >= 0x30 && rune <= 0x39) {
      buffer.write(_easternArabicDigits[rune - 0x30]);
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}

String formatPrice(BuildContext context, double value) {
  final formatted = NumberFormat.currency(
    locale: _localeTag(context),
    symbol: '\$',
    decimalDigits: 2,
  ).format(value);
  return localizeDigits(context, formatted);
}

String formatDecimal(BuildContext context, num value, {int decimalDigits = 0}) {
  final formatted = NumberFormat.decimalPatternDigits(
    locale: _localeTag(context),
    decimalDigits: decimalDigits,
  ).format(value);
  return localizeDigits(context, formatted);
}

String formatDate(BuildContext context, DateTime date) {
  return localizeDigits(context, DateFormat.yMMMd(_localeTag(context)).format(date));
}

String formatDateTime(BuildContext context, DateTime date) {
  return localizeDigits(
    context,
    DateFormat.yMMMd(_localeTag(context)).add_jm().format(date),
  );
}
