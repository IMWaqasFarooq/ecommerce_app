import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/checkout/domain/entities/address.dart';
import 'package:ecommerce_app/features/checkout/domain/repositories/address_repository.dart';
import 'package:ecommerce_app/features/checkout/presentation/providers/address_providers.dart';
import 'package:ecommerce_app/features/checkout/presentation/providers/addresses_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAddressRepository extends Mock implements AddressRepository {}

void main() {
  late _MockAddressRepository repository;
  late ProviderContainer container;

  const address = Address(
    fullName: 'Jane Doe',
    line1: '123 Main St',
    city: 'Springfield',
    state: 'IL',
    postalCode: '62704',
    country: 'USA',
    phone: '555-0100',
  );

  setUpAll(() {
    registerFallbackValue(address);
  });

  setUp(() {
    repository = _MockAddressRepository();
    container = ProviderContainer(
      overrides: [addressRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  test('build loads the saved addresses', () async {
    when(() => repository.getSavedAddresses()).thenAnswer((_) async => const Right([address]));
    container.listen(addressesProvider, (previous, next) {});

    final addresses = await container.read(addressesProvider.future);

    expect(addresses, [address]);
  });

  test('addAddress updates the state with the repository result', () async {
    when(() => repository.getSavedAddresses()).thenAnswer((_) async => const Right([]));
    when(() => repository.saveAddress(address)).thenAnswer((_) async => const Right([address]));
    container.listen(addressesProvider, (previous, next) {});
    await container.read(addressesProvider.future);

    await container.read(addressesProvider.notifier).addAddress(address);

    expect(container.read(addressesProvider).value, [address]);
  });

  test('removeAddress updates the state with the repository result', () async {
    when(() => repository.getSavedAddresses()).thenAnswer((_) async => const Right([address]));
    when(() => repository.deleteAddress(address)).thenAnswer((_) async => const Right([]));
    container.listen(addressesProvider, (previous, next) {});
    await container.read(addressesProvider.future);

    await container.read(addressesProvider.notifier).removeAddress(address);

    expect(container.read(addressesProvider).value, isEmpty);
  });
}
