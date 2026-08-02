import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_local_datasource.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  AddressRepositoryImpl({required this.localDataSource, required this.firebaseAuth});

  final AddressLocalDataSource localDataSource;
  final FirebaseAuth firebaseAuth;

  String get _ownerKey => firebaseAuth.currentUser?.uid ?? 'guest';

  List<Address> _read(String ownerKey) =>
      localDataSource.getAddresses(ownerKey).map((m) => m.toEntity()).toList();

  @override
  Future<Either<Failure, List<Address>>> getSavedAddresses() async => Right(_read(_ownerKey));

  @override
  Future<Either<Failure, List<Address>>> saveAddress(Address address) async {
    final ownerKey = _ownerKey;
    final existing = localDataSource.getAddresses(ownerKey);
    final updated = [address.toModel(), ...existing.where((a) => a.id != address.id)];
    await localDataSource.saveAddresses(ownerKey, updated);
    return Right(_read(ownerKey));
  }

  @override
  Future<Either<Failure, List<Address>>> deleteAddress(Address address) async {
    final ownerKey = _ownerKey;
    final existing = localDataSource.getAddresses(ownerKey);
    final updated = existing.where((a) => a.id != address.id).toList();
    await localDataSource.saveAddresses(ownerKey, updated);
    return Right(_read(ownerKey));
  }
}
