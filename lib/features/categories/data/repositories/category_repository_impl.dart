import 'package:dartz/dartz.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failure_code.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_datasource.dart';
import '../datasources/category_remote_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
        await localDataSource.cacheCategories(categories);
        return Right(categories.map((c) => c.toEntity()).toList());
      } catch (e) {
        final cached = await localDataSource.getCachedCategories();
        if (cached != null) return Right(cached.map((c) => c.toEntity()).toList());
        return Left(await mapExceptionToFailure(e));
      }
    }

    final cached = await localDataSource.getCachedCategories();
    if (cached != null) return Right(cached.map((c) => c.toEntity()).toList());
    return const Left(Failure.network(code: FailureCode.networkNoCachedData));
  }
}
