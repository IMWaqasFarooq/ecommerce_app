import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, Cart>> addItem({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
    int quantity = 1,
  });
  Future<Either<Failure, Cart>> updateQuantity(int productId, int quantity);
  Future<Either<Failure, Cart>> removeItem(int productId);
  Future<Either<Failure, Cart>> applyCoupon(String code);
  Future<Either<Failure, Cart>> removeCoupon();
  Future<Either<Failure, Cart>> clearCart();
  Future<void> mergeGuestCartIntoUser();
}
