import 'package:dartz/dartz.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, ({List<Product> products, int total})>> getProducts({
    required int page,
    int limit = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getProducts(page: page, limit: limit);
        await localDataSource.cacheProducts(response.products, page: page, limit: limit);
        return Right((
          products: response.products.map((p) => p.toEntity()).toList(),
          total: response.total,
        ));
      } catch (e) {
        final cached = await localDataSource.getCachedProducts(page: page, limit: limit);
        if (cached != null) {
          return Right((products: cached.map((p) => p.toEntity()).toList(), total: cached.length));
        }
        return Left(await mapExceptionToFailure(e));
      }
    }

    final cached = await localDataSource.getCachedProducts(page: page, limit: limit);
    if (cached != null) {
      return Right((products: cached.map((p) => p.toEntity()).toList(), total: cached.length));
    }
    return const Left(Failure.network(message: 'No internet connection and no cached data'));
  }

  @override
  Future<Either<Failure, Product>> getProductDetail(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.getProductDetail(id);
        await localDataSource.cacheProductDetail(product);
        return Right(product.toEntity());
      } catch (e) {
        final cached = await localDataSource.getCachedProductDetail(id);
        if (cached != null) return Right(cached.toEntity());
        return Left(await mapExceptionToFailure(e));
      }
    }

    final cached = await localDataSource.getCachedProductDetail(id);
    if (cached != null) return Right(cached.toEntity());
    return const Left(Failure.network(message: 'No internet connection and no cached data'));
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getProductsByCategory(category);
        await localDataSource.cacheProductsByCategory(category, response.products);
        return Right(response.products.map((p) => p.toEntity()).toList());
      } catch (e) {
        final cached = await localDataSource.getCachedProductsByCategory(category);
        if (cached != null) return Right(cached.map((p) => p.toEntity()).toList());
        return Left(await mapExceptionToFailure(e));
      }
    }

    final cached = await localDataSource.getCachedProductsByCategory(category);
    if (cached != null) return Right(cached.map((p) => p.toEntity()).toList());
    return const Left(Failure.network(message: 'No internet connection and no cached data'));
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    if (query.trim().isEmpty) return const Right([]);
    try {
      final response = await remoteDataSource.searchProducts(query.trim());
      return Right(response.products.map((p) => p.toEntity()).toList());
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }
}
