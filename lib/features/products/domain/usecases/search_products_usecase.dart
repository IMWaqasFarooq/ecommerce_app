import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProductsUseCase implements UseCase<List<Product>, String> {
  SearchProductsUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, List<Product>>> call(String query) => _repository.searchProducts(query);
}
