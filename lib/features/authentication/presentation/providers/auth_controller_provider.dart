import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/sign_in_with_email_password_usecase.dart';
import '../../domain/usecases/sign_up_with_email_password_usecase.dart';
import 'auth_providers.dart';

part 'auth_controller_provider.g.dart';

// keepAlive: a successful action's router redirect unmounts the calling page, which would otherwise autoDispose this mid-flight and throw on the final `state =`.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<void> signInWithGoogle() => _run(
        () => ref.read(signInWithGoogleUseCaseProvider)(const NoParams()),
        onSuccess: () => ref.read(analyticsServiceProvider).logLogin('google'),
      );

  Future<void> signInWithApple() => _run(
        () => ref.read(signInWithAppleUseCaseProvider)(const NoParams()),
        onSuccess: () => ref.read(analyticsServiceProvider).logLogin('apple'),
      );

  Future<void> signInWithEmailPassword({required String email, required String password}) => _run(
        () => ref.read(signInWithEmailPasswordUseCaseProvider)(
          SignInParams(email: email, password: password),
        ),
        onSuccess: () => ref.read(analyticsServiceProvider).logLogin('password'),
      );

  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) =>
      _run(
        () => ref.read(signUpWithEmailPasswordUseCaseProvider)(
          SignUpParams(email: email, password: password, displayName: displayName),
        ),
        onSuccess: () => ref.read(analyticsServiceProvider).logSignUp('password'),
      );

  Future<void> sendPasswordResetEmail(String email) => _run(
        () => ref.read(sendPasswordResetEmailUseCaseProvider)(email),
      );

  Future<void> signOut() => _run(
        () => ref.read(signOutUseCaseProvider)(const NoParams()),
      );

  Future<void> _run<T>(Future<Either<Failure, T>> Function() action, {Future<void> Function()? onSuccess}) async {
    state = const AsyncLoading();
    final result = await action();
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
    if (!state.hasError) await onSuccess?.call();
  }
}
