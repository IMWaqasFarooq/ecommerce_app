import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/hive_boxes.dart';
import '../../data/datasources/cart_local_datasource.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/apply_coupon_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_coupon_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';

final cartLocalDataSourceProvider = Provider<CartLocalDataSource>((ref) {
  return CartLocalDataSourceImpl(hiveBox(ref, HiveBoxes.cart));
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(
    localDataSource: ref.watch(cartLocalDataSourceProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});

final getCartUseCaseProvider = Provider((ref) => GetCartUseCase(ref.watch(cartRepositoryProvider)));
final addToCartUseCaseProvider = Provider(
  (ref) => AddToCartUseCase(ref.watch(cartRepositoryProvider)),
);
final updateCartQuantityUseCaseProvider = Provider(
  (ref) => UpdateCartQuantityUseCase(ref.watch(cartRepositoryProvider)),
);
final removeFromCartUseCaseProvider = Provider(
  (ref) => RemoveFromCartUseCase(ref.watch(cartRepositoryProvider)),
);
final applyCouponUseCaseProvider = Provider(
  (ref) => ApplyCouponUseCase(ref.watch(cartRepositoryProvider)),
);
final removeCouponUseCaseProvider = Provider(
  (ref) => RemoveCouponUseCase(ref.watch(cartRepositoryProvider)),
);
final clearCartUseCaseProvider = Provider(
  (ref) => ClearCartUseCase(ref.watch(cartRepositoryProvider)),
);
