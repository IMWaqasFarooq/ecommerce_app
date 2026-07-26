import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, ({List<Product> products, int total})>> getProducts({
    required int page,
    int limit = 20,
  });
  Future<Either<Failure, Product>> getProductDetail(int id);
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}
