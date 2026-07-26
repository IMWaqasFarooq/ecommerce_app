import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecommerce_app/features/cart/presentation/providers/cart_notifier.dart';
import 'package:ecommerce_app/features/cart/presentation/providers/cart_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCartRepository extends Mock implements CartRepository {}

void main() {
  late _MockCartRepository repository;
  late ProviderContainer container;

  const item = CartItem(productId: 1, title: 'Mascara', thumbnail: 't', price: 9.99, quantity: 1);

  setUp(() {
    repository = _MockCartRepository();
    container = ProviderContainer(overrides: [cartRepositoryProvider.overrideWithValue(repository)]);
    addTearDown(container.dispose);
  });

  test('build loads the current cart', () async {
    when(() => repository.getCart()).thenAnswer((_) async => const Right(Cart(items: [item])));
    container.listen(cartProvider, (previous, next) {});

    final cart = await container.read(cartProvider.future);

    expect(cart.items, [item]);
  });

  test('an invalid coupon returns a failure without discarding the loaded cart', () async {
    when(() => repository.getCart()).thenAnswer((_) async => const Right(Cart(items: [item])));
    when(() => repository.applyCoupon('BAD')).thenAnswer(
      (_) async => const Left(Failure.validation(message: 'Invalid coupon code')),
    );
    container.listen(cartProvider, (previous, next) {});

    await container.read(cartProvider.future);
    final failure = await container.read(cartProvider.notifier).applyCoupon('BAD');

    expect(failure, const Failure.validation(message: 'Invalid coupon code'));
    expect(container.read(cartProvider).value?.items, [item]);
  });

  test('addItem updates the state with the repository result', () async {
    when(() => repository.getCart()).thenAnswer((_) async => const Right(Cart()));
    when(() => repository.addItem(
          productId: any(named: 'productId'),
          title: any(named: 'title'),
          thumbnail: any(named: 'thumbnail'),
          price: any(named: 'price'),
          quantity: any(named: 'quantity'),
        )).thenAnswer((_) async => const Right(Cart(items: [item])));
    container.listen(cartProvider, (previous, next) {});

    await container.read(cartProvider.future);
    await container.read(cartProvider.notifier).addItem(
          productId: item.productId,
          title: item.title,
          thumbnail: item.thumbnail,
          price: item.price,
        );

    expect(container.read(cartProvider).value?.items, [item]);
  });
}
