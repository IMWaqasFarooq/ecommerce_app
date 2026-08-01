import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

class DeleteAddressUseCase implements UseCase<List<Address>, Address> {
  DeleteAddressUseCase(this._repository);
  final AddressRepository _repository;

  @override
  Future<Either<Failure, List<Address>>> call(Address params) => _repository.deleteAddress(params);
}
