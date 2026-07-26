import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class ApplyCouponUseCase implements UseCase<Cart, String> {
  ApplyCouponUseCase(this._repository);
  final CartRepository _repository;

  @override
  Future<Either<Failure, Cart>> call(String code) => _repository.applyCoupon(code);
}
