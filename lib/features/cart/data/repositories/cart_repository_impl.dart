import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../coupon_catalog.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/cart_item_model.dart';
import '../models/coupon_model.dart';

const _guestOwnerKey = 'guest';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({required this.localDataSource, required this.firebaseAuth});

  final CartLocalDataSource localDataSource;
  final FirebaseAuth firebaseAuth;

  String get _ownerKey => firebaseAuth.currentUser?.uid ?? _guestOwnerKey;

  Cart _readCart(String ownerKey) => Cart(
        items: localDataSource.getItems(ownerKey).map((m) => m.toEntity()).toList(),
        coupon: localDataSource.getCoupon(ownerKey)?.toEntity(),
      );

  @override
  Future<Either<Failure, Cart>> getCart() async => Right(_readCart(_ownerKey));

  @override
  Future<Either<Failure, Cart>> addItem({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
    int quantity = 1,
  }) async {
    final ownerKey = _ownerKey;
    final items = localDataSource.getItems(ownerKey);
    final existingIndex = items.indexWhere((i) => i.productId == productId);

    final updated = [...items];
    if (existingIndex == -1) {
      updated.add(
        CartItemModel(productId: productId, title: title, thumbnail: thumbnail, price: price, quantity: quantity),
      );
    } else {
      updated[existingIndex] =
          updated[existingIndex].copyWith(quantity: updated[existingIndex].quantity + quantity);
    }

    await localDataSource.saveItems(ownerKey, updated);
    return Right(_readCart(ownerKey));
  }

  @override
  Future<Either<Failure, Cart>> updateQuantity(int productId, int quantity) async {
    final ownerKey = _ownerKey;
    final items = localDataSource.getItems(ownerKey);

    if (quantity <= 0) {
      await localDataSource.saveItems(ownerKey, items.where((i) => i.productId != productId).toList());
      return Right(_readCart(ownerKey));
    }

    final updated = [
      for (final item in items) item.productId == productId ? item.copyWith(quantity: quantity) : item,
    ];
    await localDataSource.saveItems(ownerKey, updated);
    return Right(_readCart(ownerKey));
  }

  @override
  Future<Either<Failure, Cart>> removeItem(int productId) async {
    final ownerKey = _ownerKey;
    final items = localDataSource.getItems(ownerKey);
    await localDataSource.saveItems(ownerKey, items.where((i) => i.productId != productId).toList());
    return Right(_readCart(ownerKey));
  }

  @override
  Future<Either<Failure, Cart>> applyCoupon(String code) async {
    final normalized = code.trim().toUpperCase();
    final discount = couponCatalog[normalized];
    if (discount == null) {
      return const Left(Failure.validation(message: 'Invalid coupon code'));
    }

    final ownerKey = _ownerKey;
    await localDataSource.saveCoupon(ownerKey, CouponModel(code: normalized, discountPercentage: discount));
    return Right(_readCart(ownerKey));
  }

  @override
  Future<Either<Failure, Cart>> removeCoupon() async {
    final ownerKey = _ownerKey;
    await localDataSource.saveCoupon(ownerKey, null);
    return Right(_readCart(ownerKey));
  }

  @override
  Future<Either<Failure, Cart>> clearCart() async {
    final ownerKey = _ownerKey;
    await localDataSource.clear(ownerKey);
    return Right(_readCart(ownerKey));
  }

  @override
  Future<void> mergeGuestCartIntoUser() async {
    final userKey = _ownerKey;
    if (userKey == _guestOwnerKey) return;

    final guestItems = localDataSource.getItems(_guestOwnerKey);
    if (guestItems.isEmpty) return;

    final userItems = localDataSource.getItems(userKey);
    final merged = [...userItems];

    for (final guestItem in guestItems) {
      final index = merged.indexWhere((i) => i.productId == guestItem.productId);
      if (index == -1) {
        merged.add(guestItem);
      } else {
        merged[index] = merged[index].copyWith(quantity: merged[index].quantity + guestItem.quantity);
      }
    }

    await localDataSource.saveItems(userKey, merged);
    await localDataSource.clear(_guestOwnerKey);
  }
}
