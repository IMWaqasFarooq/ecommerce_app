import 'package:dartz/dartz.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);
  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AppUser?> watchAuthState() => _remoteDataSource.watchAuthState();

  @override
  AppUser? get currentUser => _remoteDataSource.currentUser;

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() async {
    try {
      return Right(await _remoteDataSource.signInWithGoogle());
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithApple() async {
    try {
      return Right(await _remoteDataSource.signInWithApple());
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return Right(
        await _remoteDataSource.signInWithEmailPassword(email: email, password: password),
      );
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      return Right(
        await _remoteDataSource.signUpWithEmailPassword(
          email: email,
          password: password,
          displayName: displayName,
        ),
      );
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AppUser>> updateDisplayName(String displayName) async {
    try {
      return Right(await _remoteDataSource.updateDisplayName(displayName));
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }
}
