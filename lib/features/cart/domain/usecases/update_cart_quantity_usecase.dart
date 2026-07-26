import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class UpdateCartQuantityUseCase implements UseCase<Cart, UpdateCartQuantityParams> {
  UpdateCartQuantityUseCase(this._repository);
  final CartRepository _repository;

  @override
  Future<Either<Failure, Cart>> call(UpdateCartQuantityParams params) =>
      _repository.updateQuantity(params.productId, params.quantity);
}

class UpdateCartQuantityParams extends Equatable {
  const UpdateCartQuantityParams({required this.productId, required this.quantity});

  final int productId;
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];
}
