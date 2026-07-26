import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

enum AuthProviderType { google, apple, emailPassword }

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.emailVerified = false,
  });

  factory AppUser.fromFirebaseUser(fb.User user) => AppUser(
    id: user.uid,
    email: user.email ?? '',
    displayName: user.displayName ?? (user.email?.split('@').first ?? 'User'),
    photoUrl: user.photoURL,
    emailVerified: user.emailVerified,
  );

  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final bool emailVerified;

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, emailVerified];
}
