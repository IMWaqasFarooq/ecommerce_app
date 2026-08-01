import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure_code.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/providers/core_providers.dart';
import 'package:ecommerce_app/features/authentication/domain/entities/app_user.dart';
import 'package:ecommerce_app/features/authentication/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:ecommerce_app/features/authentication/domain/usecases/sign_in_with_email_password_usecase.dart';
import 'package:ecommerce_app/features/authentication/presentation/pages/login_page.dart';
import 'package:ecommerce_app/features/authentication/presentation/providers/auth_providers.dart';
import 'package:ecommerce_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_analytics_service.dart';

class _MockSignInUseCase extends Mock implements SignInWithEmailPasswordUseCase {}

class _MockSendPasswordResetEmailUseCase extends Mock implements SendPasswordResetEmailUseCase {}

void main() {
  late _MockSignInUseCase signInUseCase;
  late _MockSendPasswordResetEmailUseCase resetUseCase;

  setUpAll(() {
    registerFallbackValue(const SignInParams(email: '', password: ''));
  });

  setUp(() {
    signInUseCase = _MockSignInUseCase();
    resetUseCase = _MockSendPasswordResetEmailUseCase();
  });

  Widget wrap() => ProviderScope(
    overrides: [
      signInWithEmailPasswordUseCaseProvider.overrideWithValue(signInUseCase),
      sendPasswordResetEmailUseCaseProvider.overrideWithValue(resetUseCase),
      analyticsServiceProvider.overrideWithValue(FakeAnalyticsService()),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LoginPage(),
    ),
  );

  testWidgets('renders the welcome copy and both credential fields', (tester) async {
    await tester.pumpWidget(wrap());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('shows validation errors instead of submitting when fields are empty', (
    tester,
  ) async {
    await tester.pumpWidget(wrap());

    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Enter your email'), findsOneWidget);
    verifyNever(() => signInUseCase(any()));
  });

  testWidgets('submits the entered credentials to the use case', (tester) async {
    when(() => signInUseCase(any())).thenAnswer(
      (_) async => const Right(AppUser(id: '1', email: 'demo@velora.dev', displayName: 'Demo')),
    );

    await tester.pumpWidget(wrap());
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'demo@velora.dev');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    verify(
      () => signInUseCase(const SignInParams(email: 'demo@velora.dev', password: 'password123')),
    ).called(1);
  });

  testWidgets('shows a spinner instead of the label while authenticating', (tester) async {
    final completer = Completer<Either<Failure, AppUser>>();
    when(() => signInUseCase(any())).thenAnswer((_) => completer.future);

    await tester.pumpWidget(wrap());
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'demo@velora.dev');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Sign in'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(
      const Right(AppUser(id: '1', email: 'demo@velora.dev', displayName: 'Demo')),
    );
    await tester.pumpAndSettle();
  });

  testWidgets('shows a snackbar with the failure message on a failed login', (tester) async {
    when(() => signInUseCase(any())).thenAnswer(
      (_) async => const Left(Failure.validation(code: FailureCode.validationEmailInvalid)),
    );

    await tester.pumpWidget(wrap());
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'demo@velora.dev');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Enter a valid email address'), findsOneWidget);
  });
}
