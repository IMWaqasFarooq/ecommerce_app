import 'package:ecommerce_app/features/wishlist/data/datasources/wishlist_local_datasource.dart';
import 'package:ecommerce_app/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:ecommerce_app/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalDataSource extends Mock implements WishlistLocalDataSource {}

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUser extends Mock implements User {}

void main() {
  late _MockLocalDataSource localDataSource;
  late _MockFirebaseAuth firebaseAuth;
  late _MockUser user;
  late WishlistRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(<WishlistItemModel>[]);
  });

  setUp(() {
    localDataSource = _MockLocalDataSource();
    firebaseAuth = _MockFirebaseAuth();
    user = _MockUser();
    repository = WishlistRepositoryImpl(localDataSource: localDataSource, firebaseAuth: firebaseAuth);
  });

  group('toggle', () {
    setUp(() => when(() => firebaseAuth.currentUser).thenReturn(null));

    test('adds the product when it is not already wishlisted', () async {
      when(() => localDataSource.getItems('guest')).thenReturn(const []);
      when(() => localDataSource.saveItems('guest', any())).thenAnswer((_) async {});

      final result = await repository.toggle(productId: 1, title: 'Mascara', thumbnail: 't', price: 9.99);

      expect(result.isRight(), isTrue);
      final captured = verify(() => localDataSource.saveItems('guest', captureAny())).captured.single
          as List<WishlistItemModel>;
      expect(captured, hasLength(1));
    });

    test('removes the product when it is already wishlisted', () async {
      when(() => localDataSource.getItems('guest')).thenReturn(const [
        WishlistItemModel(productId: 1, title: 'Mascara', thumbnail: 't', price: 9.99),
      ]);
      when(() => localDataSource.saveItems('guest', any())).thenAnswer((_) async {});

      final result = await repository.toggle(productId: 1, title: 'Mascara', thumbnail: 't', price: 9.99);

      expect(result.isRight(), isTrue);
      final captured = verify(() => localDataSource.saveItems('guest', captureAny())).captured.single
          as List<WishlistItemModel>;
      expect(captured, isEmpty);
    });
  });

  group('mergeGuestWishlistIntoUser', () {
    test('adds only the guest items not already in the user wishlist, then clears the guest wishlist', () async {
      when(() => firebaseAuth.currentUser).thenReturn(user);
      when(() => user.uid).thenReturn('user-1');
      when(() => localDataSource.getItems('guest')).thenReturn(const [
        WishlistItemModel(productId: 1, title: 'Mascara', thumbnail: 't', price: 9.99),
        WishlistItemModel(productId: 2, title: 'Lipstick', thumbnail: 't2', price: 5),
      ]);
      when(() => localDataSource.getItems('user-1')).thenReturn(const [
        WishlistItemModel(productId: 1, title: 'Mascara', thumbnail: 't', price: 9.99),
      ]);
      when(() => localDataSource.saveItems('user-1', any())).thenAnswer((_) async {});
      when(() => localDataSource.clear('guest')).thenAnswer((_) async {});

      await repository.mergeGuestWishlistIntoUser();

      final captured = verify(() => localDataSource.saveItems('user-1', captureAny())).captured.single
          as List<WishlistItemModel>;
      expect(captured, hasLength(2));
      verify(() => localDataSource.clear('guest')).called(1);
    });
  });
}
