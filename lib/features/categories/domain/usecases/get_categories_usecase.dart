import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase implements UseCase<List<Category>, NoParams> {
  GetCategoriesUseCase(this._repository);
  final CategoryRepository _repository;

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) => _repository.getCategories();
}
