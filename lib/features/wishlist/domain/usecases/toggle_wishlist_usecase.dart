import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class ToggleWishlistUseCase implements UseCase<List<WishlistItem>, ToggleWishlistParams> {
  ToggleWishlistUseCase(this._repository);
  final WishlistRepository _repository;

  @override
  Future<Either<Failure, List<WishlistItem>>> call(ToggleWishlistParams params) =>
      _repository.toggle(
        productId: params.productId,
        title: params.title,
        thumbnail: params.thumbnail,
        price: params.price,
      );
}

class ToggleWishlistParams extends Equatable {
  const ToggleWishlistParams({
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
  });

  final int productId;
  final String title;
  final String thumbnail;
  final double price;

  @override
  List<Object?> get props => [productId, title, thumbnail, price];
}
