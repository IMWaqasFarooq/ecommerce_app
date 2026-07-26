import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class ClearCartUseCase implements UseCase<Cart, NoParams> {
  ClearCartUseCase(this._repository);
  final CartRepository _repository;

  @override
  Future<Either<Failure, Cart>> call(NoParams params) => _repository.clearCart();
}
