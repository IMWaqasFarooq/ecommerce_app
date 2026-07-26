import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:ecommerce_app/features/cart/data/models/cart_item_model.dart';
import 'package:ecommerce_app/features/cart/data/models/coupon_model.dart';
import 'package:ecommerce_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalDataSource extends Mock implements CartLocalDataSource {}

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUser extends Mock implements User {}

void main() {
  late _MockLocalDataSource localDataSource;
  late _MockFirebaseAuth firebaseAuth;
  late _MockUser user;
  late CartRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(<CartItemModel>[]);
    registerFallbackValue(const CouponModel(code: 'FALLBACK', discountPercentage: 0));
  });

  setUp(() {
    localDataSource = _MockLocalDataSource();
    firebaseAuth = _MockFirebaseAuth();
    user = _MockUser();
    repository = CartRepositoryImpl(localDataSource: localDataSource, firebaseAuth: firebaseAuth);
  });

  group('as a guest', () {
    setUp(() => when(() => firebaseAuth.currentUser).thenReturn(null));

    test('addItem increments quantity when the product is already in the cart', () async {
      when(() => localDataSource.getItems('guest')).thenReturn([
        const CartItemModel(
          productId: 1,
          title: 'Mascara',
          thumbnail: 't',
          price: 9.99,
          quantity: 2,
        ),
      ]);
      when(() => localDataSource.getCoupon('guest')).thenReturn(null);
      when(() => localDataSource.saveItems('guest', any())).thenAnswer((_) async {});

      final result = await repository.addItem(
        productId: 1,
        title: 'Mascara',
        thumbnail: 't',
        price: 9.99,
      );

      expect(result.isRight(), isTrue);
      final captured =
          verify(() => localDataSource.saveItems('guest', captureAny())).captured.single
              as List<CartItemModel>;
      expect(captured.single.quantity, 3);
    });

    test('applyCoupon rejects an unknown code without touching storage', () async {
      final result = await repository.applyCoupon('NOT-REAL');

      expect(
        result,
        const Left<Failure, dynamic>(Failure.validation(message: 'Invalid coupon code')),
      );
      verifyNever(() => localDataSource.saveCoupon(any(), any()));
    });

    test('applyCoupon persists a known code', () async {
      when(() => localDataSource.saveCoupon('guest', any())).thenAnswer((_) async {});
      when(() => localDataSource.getItems('guest')).thenReturn(const []);
      when(
        () => localDataSource.getCoupon('guest'),
      ).thenReturn(const CouponModel(code: 'SAVE10', discountPercentage: 10));

      final result = await repository.applyCoupon('save10');

      expect(result.isRight(), isTrue);
      verify(
        () => localDataSource.saveCoupon(
          'guest',
          const CouponModel(code: 'SAVE10', discountPercentage: 10),
        ),
      ).called(1);
    });
  });

  group('mergeGuestCartIntoUser', () {
    test(
      'sums quantities for shared products and keeps unique ones, then clears the guest cart',
      () async {
        when(() => firebaseAuth.currentUser).thenReturn(user);
        when(() => user.uid).thenReturn('user-1');
        when(() => localDataSource.getItems('guest')).thenReturn(const [
          CartItemModel(productId: 1, title: 'Mascara', thumbnail: 't', price: 9.99, quantity: 2),
          CartItemModel(productId: 2, title: 'Lipstick', thumbnail: 't2', price: 5, quantity: 1),
        ]);
        when(() => localDataSource.getItems('user-1')).thenReturn(const [
          CartItemModel(productId: 1, title: 'Mascara', thumbnail: 't', price: 9.99, quantity: 1),
        ]);
        when(() => localDataSource.saveItems('user-1', any())).thenAnswer((_) async {});
        when(() => localDataSource.clear('guest')).thenAnswer((_) async {});

        await repository.mergeGuestCartIntoUser();

        final captured =
            verify(() => localDataSource.saveItems('user-1', captureAny())).captured.single
                as List<CartItemModel>;
        expect(captured, hasLength(2));
        expect(captured.firstWhere((i) => i.productId == 1).quantity, 3);
        expect(captured.firstWhere((i) => i.productId == 2).quantity, 1);
        verify(() => localDataSource.clear('guest')).called(1);
      },
    );

    test('does nothing when signed out', () async {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      await repository.mergeGuestCartIntoUser();

      verifyZeroInteractions(localDataSource);
    });
  });
}
