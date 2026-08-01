import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure_code.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailPasswordUseCase implements UseCase<AppUser, SignInParams> {
  SignInWithEmailPasswordUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, AppUser>> call(SignInParams params) {
    if (params.email.trim().isEmpty || !params.email.contains('@')) {
      return Future.value(const Left(Failure.validation(code: FailureCode.validationEmailInvalid)));
    }
    if (params.password.length < 6) {
      return Future.value(
        const Left(Failure.validation(code: FailureCode.validationPasswordTooShort)),
      );
    }
    return _repository.signInWithEmailPassword(
      email: params.email.trim(),
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
