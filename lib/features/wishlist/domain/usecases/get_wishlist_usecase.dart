import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlistUseCase implements UseCase<List<WishlistItem>, NoParams> {
  GetWishlistUseCase(this._repository);
  final WishlistRepository _repository;

  @override
  Future<Either<Failure, List<WishlistItem>>> call(NoParams params) => _repository.getWishlist();
}
