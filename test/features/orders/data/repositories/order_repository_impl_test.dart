import 'package:dartz/dartz.dart' hide Order;
import 'package:ecommerce_app/core/error/failure_code.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/features/orders/data/datasources/order_local_datasource.dart';
import 'package:ecommerce_app/features/orders/data/models/order_item_model.dart';
import 'package:ecommerce_app/features/orders/data/models/order_model.dart';
import 'package:ecommerce_app/features/orders/data/repositories/order_repository_impl.dart';
import 'package:ecommerce_app/features/orders/domain/entities/order_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalDataSource extends Mock implements OrderLocalDataSource {}

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUser extends Mock implements User {}

void main() {
  late _MockLocalDataSource localDataSource;
  late _MockFirebaseAuth firebaseAuth;
  late _MockUser user;
  late OrderRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(<OrderModel>[]);
  });

  setUp(() {
    localDataSource = _MockLocalDataSource();
    firebaseAuth = _MockFirebaseAuth();
    user = _MockUser();
    when(() => firebaseAuth.currentUser).thenReturn(user);
    when(() => user.uid).thenReturn('user-1');
    repository = OrderRepositoryImpl(localDataSource: localDataSource, firebaseAuth: firebaseAuth);
  });

  final processingOrder = OrderModel(
    id: 'order-1',
    items: const [
      OrderItemModel(productId: 1, title: 'Mascara', thumbnail: 't', price: 9.99, quantity: 1),
    ],
    subtotal: 9.99,
    discount: 0,
    shippingCost: 4.99,
    total: 14.98,
    shippingAddressText: '123 Main St',
    shippingMethodId: 'standard',
    status: OrderStatus.processing,
    createdAt: DateTime(2026, 1, 1),
  );

  test('createOrder prepends the new order and persists it', () async {
    when(() => localDataSource.getOrders('user-1')).thenReturn([]);
    when(() => localDataSource.saveOrders('user-1', any())).thenAnswer((_) async {});

    final result = await repository.createOrder(processingOrder.toEntity());

    expect(result.isRight(), isTrue);
    verify(() => localDataSource.saveOrders('user-1', [processingOrder])).called(1);
  });

  test('cancelOrder rejects an order that already shipped', () async {
    final shipped = processingOrder.copyWith(status: OrderStatus.shipped);
    when(() => localDataSource.getOrders('user-1')).thenReturn([shipped]);

    final result = await repository.cancelOrder('order-1');

    expect(
      result,
      const Left<Failure, dynamic>(
        Failure.validation(code: FailureCode.validationOrderNotCancellable),
      ),
    );
    verifyNever(() => localDataSource.saveOrders(any(), any()));
  });

  test('cancelOrder marks a processing order as cancelled', () async {
    when(() => localDataSource.getOrders('user-1')).thenReturn([processingOrder]);
    when(() => localDataSource.saveOrders('user-1', any())).thenAnswer((_) async {});

    final result = await repository.cancelOrder('order-1');

    expect(result.isRight(), isTrue);
    final captured =
        verify(() => localDataSource.saveOrders('user-1', captureAny())).captured.single
            as List<OrderModel>;
    expect(captured.single.status, OrderStatus.cancelled);
  });

  test('getOrderById returns a failure when the order does not exist', () async {
    when(() => localDataSource.getOrders('user-1')).thenReturn([]);

    final result = await repository.getOrderById('missing');

    expect(result, const Left<Failure, dynamic>(Failure.unknown(code: FailureCode.orderNotFound)));
  });
}
