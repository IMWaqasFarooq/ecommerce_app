import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../entities/product_sort.dart';
import '../repositories/product_repository.dart';

class GetProductsByCategoryUseCase
    implements UseCase<List<Product>, GetProductsByCategoryParams> {
  GetProductsByCategoryUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, List<Product>>> call(GetProductsByCategoryParams params) =>
      _repository.getProductsByCategory(params.category, sort: params.sort);
}

class GetProductsByCategoryParams extends Equatable {
  const GetProductsByCategoryParams({required this.category, this.sort = ProductSort.featured});

  final String category;
  final ProductSort sort;

  @override
  List<Object?> get props => [category, sort];
}
