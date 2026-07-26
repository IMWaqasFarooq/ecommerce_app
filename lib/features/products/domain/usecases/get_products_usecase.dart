import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase
    implements UseCase<({List<Product> products, int total}), GetProductsParams> {
  GetProductsUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, ({List<Product> products, int total})>> call(GetProductsParams params) {
    return _repository.getProducts(page: params.page, limit: params.limit);
  }
}

class GetProductsParams extends Equatable {
  const GetProductsParams({required this.page, this.limit = 20});

  final int page;
  final int limit;

  @override
  List<Object?> get props => [page, limit];
}
