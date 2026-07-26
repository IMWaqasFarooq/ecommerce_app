import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_local_datasource.dart';
import '../models/wishlist_item_model.dart';

const _guestOwnerKey = 'guest';

class WishlistRepositoryImpl implements WishlistRepository {
  WishlistRepositoryImpl({required this.localDataSource, required this.firebaseAuth});

  final WishlistLocalDataSource localDataSource;
  final FirebaseAuth firebaseAuth;

  String get _ownerKey => firebaseAuth.currentUser?.uid ?? _guestOwnerKey;

  List<WishlistItem> _readWishlist(String ownerKey) =>
      localDataSource.getItems(ownerKey).map((m) => m.toEntity()).toList();

  @override
  Future<Either<Failure, List<WishlistItem>>> getWishlist() async => Right(_readWishlist(_ownerKey));

  @override
  Future<Either<Failure, List<WishlistItem>>> toggle({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
  }) async {
    final ownerKey = _ownerKey;
    final items = localDataSource.getItems(ownerKey);
    final exists = items.any((i) => i.productId == productId);

    final updated = exists
        ? items.where((i) => i.productId != productId).toList()
        : [...items, WishlistItemModel(productId: productId, title: title, thumbnail: thumbnail, price: price)];

    await localDataSource.saveItems(ownerKey, updated);
    return Right(_readWishlist(ownerKey));
  }

  @override
  Future<void> mergeGuestWishlistIntoUser() async {
    final userKey = _ownerKey;
    if (userKey == _guestOwnerKey) return;

    final guestItems = localDataSource.getItems(_guestOwnerKey);
    if (guestItems.isEmpty) return;

    final userItems = localDataSource.getItems(userKey);
    final merged = [...userItems];

    for (final guestItem in guestItems) {
      if (!merged.any((i) => i.productId == guestItem.productId)) {
        merged.add(guestItem);
      }
    }

    await localDataSource.saveItems(userKey, merged);
    await localDataSource.clear(_guestOwnerKey);
  }
}
