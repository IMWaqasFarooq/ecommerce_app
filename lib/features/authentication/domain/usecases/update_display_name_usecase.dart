import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class UpdateDisplayNameUseCase implements UseCase<AppUser, String> {
  UpdateDisplayNameUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, AppUser>> call(String displayName) =>
      _repository.updateDisplayName(displayName);
}
