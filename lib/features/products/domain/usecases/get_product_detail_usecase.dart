import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductDetailUseCase implements UseCase<Product, int> {
  GetProductDetailUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, Product>> call(int productId) => _repository.getProductDetail(productId);
}
