import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> watchAuthState();
  AppUser? get currentUser;

  Future<Either<Failure, AppUser>> signInWithGoogle();
  Future<Either<Failure, AppUser>> signInWithApple();
  Future<Either<Failure, AppUser>> signInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, AppUser>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  });
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  Future<Either<Failure, AppUser>> updateDisplayName(String displayName);
  Future<Either<Failure, void>> signOut();
}
