import 'package:ecommerce_app/features/orders/data/models/order_item_model.dart';
import 'package:ecommerce_app/features/orders/data/models/order_model.dart';
import 'package:ecommerce_app/features/orders/domain/entities/order_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final model = OrderModel(
    id: 'order-1',
    items: const [
      OrderItemModel(productId: 1, title: 'Mascara', thumbnail: 't', price: 9.99, quantity: 1),
    ],
    subtotal: 9.99,
    discount: 0,
    shippingCost: 4.99,
    total: 14.98,
    shippingAddressText: '123 Main St',
    shippingMethodLabel: 'Standard shipping',
    status: OrderStatus.processing,
    createdAt: DateTime(2026, 1, 1),
  );

  test('toJson produces plain Map/String/num values Hive can store directly', () {
    final json = model.toJson();

    expect(json['items'], isA<List<dynamic>>());
    expect(json['items'].single, isA<Map<String, dynamic>>());
    expect(json['items'].single, isNot(isA<OrderItemModel>()));
  });

  test('round-trips through toJson/fromJson', () {
    final roundTripped = OrderModel.fromJson(model.toJson());

    expect(roundTripped, model);
  });
}
