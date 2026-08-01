import 'package:dartz/dartz.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failure_code.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl({required this.localDataSource, required this.firebaseAuth});

  final OrderLocalDataSource localDataSource;
  final FirebaseAuth firebaseAuth;

  String get _ownerKey => firebaseAuth.currentUser?.uid ?? 'guest';

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    final orders = localDataSource.getOrders(_ownerKey).map((m) => m.toEntity()).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Right(orders);
  }

  @override
  Future<Either<Failure, Order>> getOrderById(String id) async {
    final matches = localDataSource
        .getOrders(_ownerKey)
        .map((m) => m.toEntity())
        .where((o) => o.id == id);
    if (matches.isEmpty) return const Left(Failure.unknown(code: FailureCode.orderNotFound));
    return Right(matches.first);
  }

  @override
  Future<Either<Failure, Order>> createOrder(Order order) async {
    final ownerKey = _ownerKey;
    final orders = localDataSource.getOrders(ownerKey);
    await localDataSource.saveOrders(ownerKey, [order.toModel(), ...orders]);
    return Right(order);
  }

  @override
  Future<Either<Failure, Order>> cancelOrder(String id) async {
    final ownerKey = _ownerKey;
    final orders = localDataSource.getOrders(ownerKey);
    final index = orders.indexWhere((o) => o.id == id);
    if (index == -1) return const Left(Failure.unknown(code: FailureCode.orderNotFound));

    final current = orders[index].toEntity();
    if (!current.isCancellable) {
      return const Left(Failure.validation(code: FailureCode.validationOrderNotCancellable));
    }

    final cancelled = current.copyWith(status: OrderStatus.cancelled);
    final updated = [...orders]..[index] = cancelled.toModel();
    await localDataSource.saveOrders(ownerKey, updated);
    return Right(cancelled);
  }
}
