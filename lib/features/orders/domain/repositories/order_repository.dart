import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failures.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<Order>>> getOrders();
  Future<Either<Failure, Order>> getOrderById(String id);
  Future<Either<Failure, Order>> createOrder(Order order);
  Future<Either<Failure, Order>> cancelOrder(String id);
}
