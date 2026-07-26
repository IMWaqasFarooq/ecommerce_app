import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class RemoveCouponUseCase implements UseCase<Cart, NoParams> {
  RemoveCouponUseCase(this._repository);
  final CartRepository _repository;

  @override
  Future<Either<Failure, Cart>> call(NoParams params) => _repository.removeCoupon();
}
