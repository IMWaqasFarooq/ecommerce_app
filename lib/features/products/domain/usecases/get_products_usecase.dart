import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../entities/product_sort.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase
    implements UseCase<({List<Product> products, int total}), GetProductsParams> {
  GetProductsUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, ({List<Product> products, int total})>> call(GetProductsParams params) {
    return _repository.getProducts(page: params.page, limit: params.limit, sort: params.sort);
  }
}

class GetProductsParams extends Equatable {
  const GetProductsParams({required this.page, this.limit = 20, this.sort = ProductSort.featured});

  final int page;
  final int limit;
  final ProductSort sort;

  @override
  List<Object?> get props => [page, limit, sort];
}
