import 'package:equatable/equatable.dart';

import 'order_item.dart';
import 'order_status.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.shippingCost,
    required this.total,
    required this.shippingAddressText,
    required this.shippingMethodId,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final double shippingCost;
  final double total;
  final String shippingAddressText;
  final String shippingMethodId;
  final OrderStatus status;
  final DateTime createdAt;

  bool get isCancellable => status == OrderStatus.processing;

  Order copyWith({OrderStatus? status}) => Order(
    id: id,
    items: items,
    subtotal: subtotal,
    discount: discount,
    shippingCost: shippingCost,
    total: total,
    shippingAddressText: shippingAddressText,
    shippingMethodId: shippingMethodId,
    status: status ?? this.status,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [
    id,
    items,
    subtotal,
    discount,
    shippingCost,
    total,
    shippingAddressText,
    shippingMethodId,
    status,
    createdAt,
  ];
}
