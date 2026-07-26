import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/hive_boxes.dart';
import '../../data/datasources/address_local_datasource.dart';
import '../../data/repositories/address_repository_impl.dart';
import '../../domain/repositories/address_repository.dart';
import '../../domain/usecases/get_saved_addresses_usecase.dart';
import '../../domain/usecases/save_address_usecase.dart';

final addressLocalDataSourceProvider = Provider<AddressLocalDataSource>((ref) {
  return AddressLocalDataSourceImpl(hiveBox(ref, HiveBoxes.preferences));
});

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepositoryImpl(
    localDataSource: ref.watch(addressLocalDataSourceProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});

final getSavedAddressesUseCaseProvider =
    Provider((ref) => GetSavedAddressesUseCase(ref.watch(addressRepositoryProvider)));
final saveAddressUseCaseProvider = Provider((ref) => SaveAddressUseCase(ref.watch(addressRepositoryProvider)));
