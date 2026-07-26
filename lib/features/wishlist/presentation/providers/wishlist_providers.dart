import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/hive_boxes.dart';
import '../../data/datasources/wishlist_local_datasource.dart';
import '../../data/repositories/wishlist_repository_impl.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../../domain/usecases/get_wishlist_usecase.dart';
import '../../domain/usecases/toggle_wishlist_usecase.dart';

final wishlistLocalDataSourceProvider = Provider<WishlistLocalDataSource>((ref) {
  return WishlistLocalDataSourceImpl(hiveBox(ref, HiveBoxes.wishlist));
});

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepositoryImpl(
    localDataSource: ref.watch(wishlistLocalDataSourceProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});

final getWishlistUseCaseProvider = Provider(
  (ref) => GetWishlistUseCase(ref.watch(wishlistRepositoryProvider)),
);
final toggleWishlistUseCaseProvider = Provider(
  (ref) => ToggleWishlistUseCase(ref.watch(wishlistRepositoryProvider)),
);
