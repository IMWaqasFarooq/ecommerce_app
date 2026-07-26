import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase implements UseCase<Order, Order> {
  CreateOrderUseCase(this._repository);
  final OrderRepository _repository;

  @override
  Future<Either<Failure, Order>> call(Order params) => _repository.createOrder(params);
}
