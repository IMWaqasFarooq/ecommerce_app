import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase implements UseCase<Cart, AddToCartParams> {
  AddToCartUseCase(this._repository);
  final CartRepository _repository;

  @override
  Future<Either<Failure, Cart>> call(AddToCartParams params) => _repository.addItem(
    productId: params.productId,
    title: params.title,
    thumbnail: params.thumbnail,
    price: params.price,
    quantity: params.quantity,
  );
}

class AddToCartParams extends Equatable {
  const AddToCartParams({
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
    this.quantity = 1,
  });

  final int productId;
  final String title;
  final String thumbnail;
  final double price;
  final int quantity;

  @override
  List<Object?> get props => [productId, title, thumbnail, price, quantity];
}
