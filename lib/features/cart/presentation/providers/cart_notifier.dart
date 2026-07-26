import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/cart.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';
import 'cart_providers.dart';

part 'cart_notifier.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  Future<Cart> build() async {
    final result = await ref.watch(getCartUseCaseProvider)(const NoParams());
    return result.fold((failure) => throw failure, (cart) => cart);
  }

  Future<Failure?> addItem({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
    int quantity = 1,
  }) async {
    final failure = await _mutate(
      ref.read(addToCartUseCaseProvider)(
        AddToCartParams(productId: productId, title: title, thumbnail: thumbnail, price: price, quantity: quantity),
      ),
    );
    if (failure == null) {
      await ref.read(analyticsServiceProvider).logAddToCart(productId: productId, name: title, price: price);
    }
    return failure;
  }

  Future<Failure?> updateQuantity(int productId, int quantity) {
    return _mutate(
      ref.read(updateCartQuantityUseCaseProvider)(
        UpdateCartQuantityParams(productId: productId, quantity: quantity),
      ),
    );
  }

  Future<Failure?> removeItem(int productId) {
    return _mutate(ref.read(removeFromCartUseCaseProvider)(productId));
  }

  Future<Failure?> applyCoupon(String code) {
    return _mutate(ref.read(applyCouponUseCaseProvider)(code));
  }

  Future<Failure?> removeCoupon() {
    return _mutate(ref.read(removeCouponUseCaseProvider)(const NoParams()));
  }

  Future<Failure?> clearCart() {
    return _mutate(ref.read(clearCartUseCaseProvider)(const NoParams()));
  }

  Future<Failure?> _mutate(Future<Either<Failure, Cart>> operation) async {
    final result = await operation;
    return result.fold((failure) => failure, (cart) {
      state = AsyncData(cart);
      return null;
    });
  }
}
