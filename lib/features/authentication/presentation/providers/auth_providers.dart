import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import '../../domain/usecases/sign_in_with_apple_usecase.dart';
import '../../domain/usecases/sign_in_with_email_password_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_with_email_password_usecase.dart';
import '../../domain/usecases/watch_auth_state_usecase.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn.instance);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(firebaseAuthProvider), ref.watch(googleSignInProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

final watchAuthStateUseCaseProvider = Provider<WatchAuthStateUseCase>((ref) {
  return WatchAuthStateUseCase(ref.watch(authRepositoryProvider));
});

final signInWithGoogleUseCaseProvider = Provider<SignInWithGoogleUseCase>((ref) {
  return SignInWithGoogleUseCase(ref.watch(authRepositoryProvider));
});

final signInWithAppleUseCaseProvider = Provider<SignInWithAppleUseCase>((ref) {
  return SignInWithAppleUseCase(ref.watch(authRepositoryProvider));
});

final signInWithEmailPasswordUseCaseProvider = Provider<SignInWithEmailPasswordUseCase>((ref) {
  return SignInWithEmailPasswordUseCase(ref.watch(authRepositoryProvider));
});

final signUpWithEmailPasswordUseCaseProvider = Provider<SignUpWithEmailPasswordUseCase>((ref) {
  return SignUpWithEmailPasswordUseCase(ref.watch(authRepositoryProvider));
});

final sendPasswordResetEmailUseCaseProvider = Provider<SendPasswordResetEmailUseCase>((ref) {
  return SendPasswordResetEmailUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});
