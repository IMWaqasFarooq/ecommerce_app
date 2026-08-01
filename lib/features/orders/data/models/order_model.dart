import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import 'order_item_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
abstract class OrderModel with _$OrderModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory OrderModel({
    required String id,
    required List<OrderItemModel> items,
    required double subtotal,
    required double discount,
    required double shippingCost,
    required double total,
    required String shippingAddressText,
    required String shippingMethodId,
    required OrderStatus status,
    required DateTime createdAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}

extension OrderModelMapper on OrderModel {
  Order toEntity() => Order(
    id: id,
    items: items.map((i) => i.toEntity()).toList(),
    subtotal: subtotal,
    discount: discount,
    shippingCost: shippingCost,
    total: total,
    shippingAddressText: shippingAddressText,
    shippingMethodId: shippingMethodId,
    status: status,
    createdAt: createdAt,
  );
}

extension OrderEntityMapper on Order {
  OrderModel toModel() => OrderModel(
    id: id,
    items: items.map((i) => i.toModel()).toList(),
    subtotal: subtotal,
    discount: discount,
    shippingCost: shippingCost,
    total: total,
    shippingAddressText: shippingAddressText,
    shippingMethodId: shippingMethodId,
    status: status,
    createdAt: createdAt,
  );
}
