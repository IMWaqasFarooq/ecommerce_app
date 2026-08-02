import 'package:ecommerce_app/core/formatting/locale_formatting.dart';
import 'package:ecommerce_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<String> formatIn(WidgetTester tester, double meters) async {
    late String result;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            result = formatDistance(context, meters);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return result;
  }

  testWidgets('formats sub-kilometer distances in meters', (tester) async {
    expect(await formatIn(tester, 13), '13 m');
  });

  testWidgets('rounds meters to the nearest whole number', (tester) async {
    expect(await formatIn(tester, 499.6), '500 m');
  });

  testWidgets('formats distances of 1 km or more in kilometers with one decimal', (tester) async {
    expect(await formatIn(tester, 7400), '7.4 km');
  });

  testWidgets('formats exactly 1000 meters as 1.0 km', (tester) async {
    expect(await formatIn(tester, 1000), '1.0 km');
  });
}
