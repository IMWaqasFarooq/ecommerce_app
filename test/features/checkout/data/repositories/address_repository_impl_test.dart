import 'package:ecommerce_app/features/checkout/data/datasources/address_local_datasource.dart';
import 'package:ecommerce_app/features/checkout/data/models/address_model.dart';
import 'package:ecommerce_app/features/checkout/data/repositories/address_repository_impl.dart';
import 'package:ecommerce_app/features/checkout/domain/entities/address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalDataSource extends Mock implements AddressLocalDataSource {}

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late _MockLocalDataSource localDataSource;
  late _MockFirebaseAuth firebaseAuth;
  late AddressRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(<AddressModel>[]);
  });

  setUp(() {
    localDataSource = _MockLocalDataSource();
    firebaseAuth = _MockFirebaseAuth();
    when(() => firebaseAuth.currentUser).thenReturn(null);
    repository = AddressRepositoryImpl(localDataSource: localDataSource, firebaseAuth: firebaseAuth);
  });

  const address = Address(
    fullName: 'Jane Doe',
    line1: '123 Main St',
    city: 'Springfield',
    state: 'IL',
    postalCode: '62704',
    country: 'USA',
    phone: '555-0100',
  );

  test('saveAddress prepends the new address ahead of the existing ones', () async {
    when(() => localDataSource.getAddresses('guest')).thenReturn(const []);
    when(() => localDataSource.saveAddresses('guest', any())).thenAnswer((_) async {});

    final result = await repository.saveAddress(address);

    expect(result.isRight(), isTrue);
    final captured =
        verify(() => localDataSource.saveAddresses('guest', captureAny())).captured.single as List<AddressModel>;
    expect(captured, [address.toModel()]);
  });

  test('deleteAddress removes a matching saved address', () async {
    when(() => localDataSource.getAddresses('guest')).thenReturn([address.toModel()]);
    when(() => localDataSource.saveAddresses('guest', any())).thenAnswer((_) async {});

    final result = await repository.deleteAddress(address);

    expect(result.isRight(), isTrue);
    final captured =
        verify(() => localDataSource.saveAddresses('guest', captureAny())).captured.single as List<AddressModel>;
    expect(captured, isEmpty);
  });
}
