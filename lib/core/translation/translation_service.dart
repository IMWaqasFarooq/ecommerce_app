import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translator/translator.dart';

abstract class TranslationService {
  Future<String> translate(String text, {required String to, String from = 'en'});
}

class GoogleTranslateService implements TranslationService {
  GoogleTranslateService(this._translator);
  final GoogleTranslator _translator;

  @override
  Future<String> translate(String text, {required String to, String from = 'en'}) async {
    final translation = await _translator.translate(text, from: from, to: to);
    return translation.text;
  }
}

final translationServiceProvider = Provider<TranslationService>((ref) {
  return GoogleTranslateService(GoogleTranslator());
});

Future<String> translateWithFallback(
  TranslationService service,
  String text, {
  required String to,
}) async {
  try {
    return await service.translate(text, to: to);
  } catch (e) {
    debugPrint('Translation failed for "$text": $e');
    return text;
  }
}
