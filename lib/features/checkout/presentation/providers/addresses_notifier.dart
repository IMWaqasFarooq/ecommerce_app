import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/address.dart';
import 'address_providers.dart';

part 'addresses_notifier.g.dart';

@riverpod
class AddressesNotifier extends _$AddressesNotifier {
  @override
  Future<List<Address>> build() async {
    final result = await ref.watch(getSavedAddressesUseCaseProvider)(const NoParams());
    return result.fold((failure) => throw failure, (addresses) => addresses);
  }

  Future<void> addAddress(Address address) async {
    final result = await ref.read(saveAddressUseCaseProvider)(address);
    result.fold((failure) {}, (addresses) => state = AsyncData(addresses));
  }

  Future<void> removeAddress(Address address) async {
    final result = await ref.read(deleteAddressUseCaseProvider)(address);
    result.fold((failure) {}, (addresses) => state = AsyncData(addresses));
  }
}
