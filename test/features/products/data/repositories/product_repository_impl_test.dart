import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_local_datasource.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_remote_datasource.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:ecommerce_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}

class _MockLocalDataSource extends Mock implements ProductLocalDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late _MockRemoteDataSource remoteDataSource;
  late _MockLocalDataSource localDataSource;
  late _MockNetworkInfo networkInfo;
  late ProductRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockRemoteDataSource();
    localDataSource = _MockLocalDataSource();
    networkInfo = _MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  const productModel = ProductModel(
    id: 1,
    title: 'Essence Mascara',
    description: 'A mascara',
    category: 'beauty',
    price: 9.99,
    thumbnail: 'https://example.com/thumb.png',
  );

  group('getProductDetail', () {
    test('returns remote data and caches it when online', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getProductDetail(1)).thenAnswer((_) async => productModel);
      when(() => localDataSource.cacheProductDetail(productModel)).thenAnswer((_) async {});

      final result = await repository.getProductDetail(1);

      expect(result, Right(productModel.toEntity()));
      verify(() => localDataSource.cacheProductDetail(productModel)).called(1);
    });

    test('falls back to cache when the remote call throws and cache has data', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getProductDetail(1)).thenThrow(const ServerException('boom'));
      when(() => localDataSource.getCachedProductDetail(1)).thenAnswer((_) async => productModel);

      final result = await repository.getProductDetail(1);

      expect(result, Right(productModel.toEntity()));
    });

    test('returns a network failure when offline with no cache', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => localDataSource.getCachedProductDetail(1)).thenAnswer((_) async => null);

      final result = await repository.getProductDetail(1);

      expect(
        result,
        const Left<Failure, dynamic>(
          Failure.network(message: 'No internet connection and no cached data'),
        ),
      );
    });
  });

  group('searchProducts', () {
    test('returns an empty list without calling the remote source for a blank query', () async {
      final result = await repository.searchProducts('   ');

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (products) => expect(products, isEmpty));
      verifyZeroInteractions(remoteDataSource);
    });
  });
}
