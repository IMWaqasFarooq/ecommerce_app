import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/error/exceptions.dart';
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
        throw const UnauthorizedException('Google sign-in did not return an identity token');
      }
      final credential = fb.GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return AppUser.fromFirebaseUser(userCredential.user!);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const UnauthorizedException('Sign-in cancelled');
      }
      throw UnauthorizedException('Google sign-in failed: ${e.description ?? e.code}');
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(_messageForFirebaseError(e));
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
        throw const UnauthorizedException('Sign-in cancelled');
      }
      throw UnauthorizedException('Apple sign-in failed: ${e.message}');
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(_messageForFirebaseError(e));
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
      throw ServerException(_messageForFirebaseError(e));
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
      throw ServerException(_messageForFirebaseError(e));
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(_messageForFirebaseError(e));
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
      throw ServerException(_messageForFirebaseError(e));
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      if (_googleSignInInitialized) _googleSignIn.signOut(),
    ]);
  }

  String _messageForFirebaseError(fb.FirebaseAuthException e) {
    return switch (e.code) {
      'user-not-found' => 'No account found for that email',
      'wrong-password' || 'invalid-credential' => 'Incorrect email or password',
      'email-already-in-use' => 'An account already exists for that email',
      'weak-password' => 'Choose a stronger password',
      'invalid-email' => 'Enter a valid email address',
      'user-disabled' => 'This account has been disabled',
      'too-many-requests' => 'Too many attempts, please try again later',
      'network-request-failed' => 'Network error, check your connection',
      _ => e.message ?? 'Authentication failed',
    };
  }
}
