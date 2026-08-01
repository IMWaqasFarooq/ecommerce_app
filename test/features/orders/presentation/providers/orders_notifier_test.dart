import 'package:dartz/dartz.dart' hide Order;
import 'package:ecommerce_app/core/error/failure_code.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/features/orders/domain/entities/order.dart';
import 'package:ecommerce_app/features/orders/domain/entities/order_status.dart';
import 'package:ecommerce_app/features/orders/domain/repositories/order_repository.dart';
import 'package:ecommerce_app/features/orders/presentation/providers/order_providers.dart';
import 'package:ecommerce_app/features/orders/presentation/providers/orders_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late _MockOrderRepository repository;
  late ProviderContainer container;

  Order order(String id, OrderStatus status) => Order(
    id: id,
    items: const [],
    subtotal: 10,
    discount: 0,
    shippingCost: 5,
    total: 15,
    shippingAddressText: '123 Main St',
    shippingMethodId: 'standard',
    status: status,
    createdAt: DateTime(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(order('fallback', OrderStatus.processing));
  });

  setUp(() {
    repository = _MockOrderRepository();
    container = ProviderContainer(
      overrides: [orderRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  test('cancelOrder replaces only the matching order with its cancelled copy', () async {
    final orders = [
      order('order-1', OrderStatus.processing),
      order('order-2', OrderStatus.processing),
    ];
    when(() => repository.getOrders()).thenAnswer((_) async => Right(orders));
    when(
      () => repository.cancelOrder('order-1'),
    ).thenAnswer((_) async => Right(order('order-1', OrderStatus.cancelled)));

    container.listen(ordersProvider, (previous, next) {});
    await container.read(ordersProvider.future);

    final failure = await container.read(ordersProvider.notifier).cancelOrder('order-1');

    expect(failure, isNull);
    final updated = container.read(ordersProvider).value!;
    expect(updated.firstWhere((o) => o.id == 'order-1').status, OrderStatus.cancelled);
    expect(updated.firstWhere((o) => o.id == 'order-2').status, OrderStatus.processing);
  });

  test('cancelOrder surfaces a failure and leaves the list untouched', () async {
    final orders = [order('order-1', OrderStatus.shipped)];
    when(() => repository.getOrders()).thenAnswer((_) async => Right(orders));
    when(() => repository.cancelOrder('order-1')).thenAnswer(
      (_) async =>
          const Left(Failure.validation(code: FailureCode.validationOrderNotCancellable)),
    );

    container.listen(ordersProvider, (previous, next) {});
    await container.read(ordersProvider.future);

    final failure = await container.read(ordersProvider.notifier).cancelOrder('order-1');

    expect(failure, const Failure.validation(code: FailureCode.validationOrderNotCancellable));
    expect(container.read(ordersProvider).value!.single.status, OrderStatus.shipped);
  });
}
