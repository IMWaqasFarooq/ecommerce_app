import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SendPasswordResetEmailUseCase implements UseCase<void, String> {
  SendPasswordResetEmailUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(String email) {
    if (email.trim().isEmpty || !email.contains('@')) {
      return Future.value(const Left(Failure.validation(message: 'Enter a valid email address')));
    }
    return _repository.sendPasswordResetEmail(email.trim());
  }
}
