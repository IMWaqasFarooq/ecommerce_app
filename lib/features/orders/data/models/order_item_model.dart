import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/order_item.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@freezed
abstract class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
    required int quantity,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);
}

extension OrderItemModelMapper on OrderItemModel {
  OrderItem toEntity() =>
      OrderItem(productId: productId, title: title, thumbnail: thumbnail, price: price, quantity: quantity);
}

extension OrderItemEntityMapper on OrderItem {
  OrderItemModel toModel() =>
      OrderItemModel(productId: productId, title: title, thumbnail: thumbnail, price: price, quantity: quantity);
}
