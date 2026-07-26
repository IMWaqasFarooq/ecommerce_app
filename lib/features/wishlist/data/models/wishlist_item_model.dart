import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/wishlist_item.dart';

part 'wishlist_item_model.freezed.dart';
part 'wishlist_item_model.g.dart';

@freezed
abstract class WishlistItemModel with _$WishlistItemModel {
  const factory WishlistItemModel({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
  }) = _WishlistItemModel;

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) => _$WishlistItemModelFromJson(json);
}

extension WishlistItemModelMapper on WishlistItemModel {
  WishlistItem toEntity() => WishlistItem(productId: productId, title: title, thumbnail: thumbnail, price: price);
}
