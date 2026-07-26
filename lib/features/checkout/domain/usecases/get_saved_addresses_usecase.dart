import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

class GetSavedAddressesUseCase implements UseCase<List<Address>, NoParams> {
  GetSavedAddressesUseCase(this._repository);
  final AddressRepository _repository;

  @override
  Future<Either<Failure, List<Address>>> call(NoParams params) => _repository.getSavedAddresses();
}
