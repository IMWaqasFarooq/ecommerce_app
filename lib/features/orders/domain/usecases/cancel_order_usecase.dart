import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CancelOrderUseCase implements UseCase<Order, String> {
  CancelOrderUseCase(this._repository);
  final OrderRepository _repository;

  @override
  Future<Either<Failure, Order>> call(String id) => _repository.cancelOrder(id);
}
