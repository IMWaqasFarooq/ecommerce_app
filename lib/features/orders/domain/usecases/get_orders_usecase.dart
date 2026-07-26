import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrdersUseCase implements UseCase<List<Order>, NoParams> {
  GetOrdersUseCase(this._repository);
  final OrderRepository _repository;

  @override
  Future<Either<Failure, List<Order>>> call(NoParams params) => _repository.getOrders();
}
