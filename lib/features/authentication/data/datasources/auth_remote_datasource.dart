import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_code.dart';
import '../../domain/entities/app_user.dart';

abstract class AuthRemoteDataSource {
  Stream<AppUser?> watchAuthState();
  AppUser? get currentUser;

  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithApple();
  Future<AppUser> signInWithEmailPassword({required String email, required String password});
  Future<AppUser> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  });
  Future<void> sendPasswordResetEmail(String email);
  Future<AppUser> updateDisplayName(String displayName);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._firebaseAuth, this._googleSignIn);

  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  bool _googleSignInInitialized = false;

  @override
  Stream<AppUser?> watchAuthState() {
    // userChanges(), not authStateChanges(), so profile edits like updateDisplayName() are reflected too.
    return _firebaseAuth.userChanges().map(_mapUser);
  }

  @override
  AppUser? get currentUser => _mapUser(_firebaseAuth.currentUser);

  AppUser? _mapUser(fb.User? user) => user == null ? null : AppUser.fromFirebaseUser(user);

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      if (!_googleSignInInitialized) {
        await _googleSignIn.initialize();
        _googleSignInInitialized = true;
      }
      final account = await _googleSignIn.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const UnauthorizedException(FailureCode.authGoogleFailed);
      }
      final credential = fb.GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return AppUser.fromFirebaseUser(userCredential.user!);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const UnauthorizedException(FailureCode.authCancelled);
      }
      debugPrint('Google sign-in failed: ${e.description ?? e.code}');
      throw const UnauthorizedException(FailureCode.authGoogleFailed);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(_codeForFirebaseError(e));
    }
  }

  @override
  Future<AppUser> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      final oauthCredential = fb.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);
      final user = userCredential.user!;

      final hasName = appleCredential.givenName != null || appleCredential.familyName != null;
      if (hasName && (user.displayName == null || user.displayName!.isEmpty)) {
        final fullName = '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
            .trim();
        if (fullName.isNotEmpty) await user.updateDisplayName(fullName);
      }
      await user.reload();
      return AppUser.fromFirebaseUser(_firebaseAuth.currentUser!);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const UnauthorizedException(FailureCode.authCancelled);
      }
      debugPrint('Apple sign-in failed: ${e.message}');
      throw const UnauthorizedException(FailureCode.authAppleFailed);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(_codeForFirebaseError(e));
    }
  }

  @override
  Future<AppUser> signInWithEmailPassword({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AppUser.fromFirebaseUser(userCredential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(_codeForFirebaseError(e));
    }
  }

  @override
  Future<AppUser> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(displayName);
      await userCredential.user?.reload();
      return AppUser.fromFirebaseUser(_firebaseAuth.currentUser!);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(_codeForFirebaseError(e));
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(_codeForFirebaseError(e));
    }
  }

  @override
  Future<AppUser> updateDisplayName(String displayName) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw const UnauthorizedException();
      await user.updateDisplayName(displayName);
      await user.reload();
      return AppUser.fromFirebaseUser(_firebaseAuth.currentUser!);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(_codeForFirebaseError(e));
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      if (_googleSignInInitialized) _googleSignIn.signOut(),
    ]);
  }

  FailureCode _codeForFirebaseError(fb.FirebaseAuthException e) {
    final code = switch (e.code) {
      'user-not-found' => FailureCode.authUserNotFound,
      'wrong-password' || 'invalid-credential' => FailureCode.authWrongPassword,
      'email-already-in-use' => FailureCode.authEmailInUse,
      'weak-password' => FailureCode.authWeakPassword,
      'invalid-email' => FailureCode.authInvalidEmail,
      'user-disabled' => FailureCode.authUserDisabled,
      'too-many-requests' => FailureCode.authTooManyRequests,
      'network-request-failed' => FailureCode.authNetworkRequestFailed,
      _ => FailureCode.authGeneric,
    };
    if (code == FailureCode.authGeneric) {
      debugPrint('Unmapped Firebase auth error ${e.code}: ${e.message}');
    }
    return code;
  }
}
