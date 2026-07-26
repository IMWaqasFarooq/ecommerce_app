import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase implements UseCase<Cart, NoParams> {
  GetCartUseCase(this._repository);
  final CartRepository _repository;

  @override
  Future<Either<Failure, Cart>> call(NoParams params) => _repository.getCart();
}
