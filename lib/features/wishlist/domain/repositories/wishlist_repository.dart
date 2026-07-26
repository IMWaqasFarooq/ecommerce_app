import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/wishlist_item.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<WishlistItem>>> getWishlist();
  Future<Either<Failure, List<WishlistItem>>> toggle({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
  });
  Future<void> mergeGuestWishlistIntoUser();
}
