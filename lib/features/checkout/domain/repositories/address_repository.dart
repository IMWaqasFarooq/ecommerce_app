import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/address.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<Address>>> getSavedAddresses();
  Future<Either<Failure, List<Address>>> saveAddress(Address address);
  Future<Either<Failure, List<Address>>> deleteAddress(Address address);
}
