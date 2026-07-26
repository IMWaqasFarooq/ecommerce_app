import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailPasswordUseCase implements UseCase<AppUser, SignUpParams> {
  SignUpWithEmailPasswordUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, AppUser>> call(SignUpParams params) {
    if (params.displayName.trim().isEmpty) {
      return Future.value(const Left(Failure.validation(message: 'Enter your name')));
    }
    if (params.email.trim().isEmpty || !params.email.contains('@')) {
      return Future.value(const Left(Failure.validation(message: 'Enter a valid email address')));
    }
    if (params.password.length < 6) {
      return Future.value(
        const Left(Failure.validation(message: 'Password must be at least 6 characters')),
      );
    }
    return _repository.signUpWithEmailPassword(
      email: params.email.trim(),
      password: params.password,
      displayName: params.displayName.trim(),
    );
  }
}

class SignUpParams extends Equatable {
  const SignUpParams({required this.email, required this.password, required this.displayName});

  final String email;
  final String password;
  final String displayName;

  @override
  List<Object?> get props => [email, password, displayName];
}
