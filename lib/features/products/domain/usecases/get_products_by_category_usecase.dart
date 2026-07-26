import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsByCategoryUseCase implements UseCase<List<Product>, String> {
  GetProductsByCategoryUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, List<Product>>> call(String category) =>
      _repository.getProductsByCategory(category);
}
