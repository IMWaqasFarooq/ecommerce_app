import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/cart_item.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
abstract class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
    required int quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);
}

extension CartItemModelMapper on CartItemModel {
  CartItem toEntity() =>
      CartItem(productId: productId, title: title, thumbnail: thumbnail, price: price, quantity: quantity);
}

extension CartItemEntityMapper on CartItem {
  CartItemModel toModel() =>
      CartItemModel(productId: productId, title: title, thumbnail: thumbnail, price: price, quantity: quantity);
}
