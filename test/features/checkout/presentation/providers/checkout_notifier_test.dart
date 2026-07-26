import 'package:dartz/dartz.dart' hide Order;
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecommerce_app/features/cart/presentation/providers/cart_notifier.dart';
import 'package:ecommerce_app/features/cart/presentation/providers/cart_providers.dart';
import 'package:ecommerce_app/features/checkout/domain/entities/address.dart';
import 'package:ecommerce_app/features/checkout/domain/entities/shipping_method.dart';
import 'package:ecommerce_app/features/checkout/domain/repositories/address_repository.dart';
import 'package:ecommerce_app/features/checkout/presentation/providers/address_providers.dart';
import 'package:ecommerce_app/features/checkout/presentation/providers/checkout_notifier.dart';
import 'package:ecommerce_app/features/checkout/presentation/providers/checkout_state.dart';
import 'package:ecommerce_app/features/orders/domain/entities/order.dart';
import 'package:ecommerce_app/features/orders/domain/entities/order_status.dart';
import 'package:ecommerce_app/features/orders/domain/repositories/order_repository.dart';
import 'package:ecommerce_app/features/orders/presentation/providers/order_providers.dart';
import 'package:ecommerce_app/features/payments/domain/repositories/payment_gateway.dart';
import 'package:ecommerce_app/features/payments/presentation/providers/payment_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCartRepository extends Mock implements CartRepository {}

class _MockAddressRepository extends Mock implements AddressRepository {}

class _MockPaymentGateway extends Mock implements PaymentGateway {}

class _MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late _MockCartRepository cartRepository;
  late _MockAddressRepository addressRepository;
  late _MockPaymentGateway paymentGateway;
  late _MockOrderRepository orderRepository;
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

  const cartItem = CartItem(productId: 1, title: 'Mascara', thumbnail: 't', price: 9.99, quantity: 2);
  const cart = Cart(items: [cartItem]);

  setUpAll(() {
    registerFallbackValue(cart);
    registerFallbackValue(
      Order(
        id: 'fallback',
        items: [],
        subtotal: 0,
        discount: 0,
        shippingCost: 0,
        total: 0,
        shippingAddressText: '',
        shippingMethodLabel: '',
        status: OrderStatus.processing,
        createdAt: DateTime(2026),
      ),
    );
  });

  setUp(() {
    cartRepository = _MockCartRepository();
    addressRepository = _MockAddressRepository();
    paymentGateway = _MockPaymentGateway();
    orderRepository = _MockOrderRepository();

    when(() => addressRepository.getSavedAddresses()).thenAnswer((_) async => const Right([address]));
    when(() => cartRepository.getCart()).thenAnswer((_) async => const Right(cart));
    when(() => cartRepository.clearCart()).thenAnswer((_) async => const Right(Cart()));

    container = ProviderContainer(
      overrides: [
        cartRepositoryProvider.overrideWithValue(cartRepository),
        addressRepositoryProvider.overrideWithValue(addressRepository),
        paymentGatewayProvider.overrideWithValue(paymentGateway),
        orderRepositoryProvider.overrideWithValue(orderRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  test('build preselects the first saved address', () async {
    container.listen(checkoutProvider, (previous, next) {});

    final state = await container.read(checkoutProvider.future);

    expect(state.selectedAddress, address);
    expect(state.step, CheckoutStep.address);
  });

  test('selecting shipping advances straight to the payment step', () async {
    container.listen(checkoutProvider, (previous, next) {});
    await container.read(checkoutProvider.future);
    container.read(cartProvider.notifier);
    container.listen(cartProvider, (previous, next) {});
    await container.read(cartProvider.future);

    container.read(checkoutProvider.notifier).selectShipping(ShippingMethod.all.first);

    final state = container.read(checkoutProvider).value!;
    expect(state.step, CheckoutStep.payment);
    expect(state.selectedShipping, ShippingMethod.all.first);
  });

  test('placeOrder charges the card, creates the order, and empties the cart on success', () async {
    when(() => paymentGateway.pay(amountInSmallestUnit: any(named: 'amountInSmallestUnit'), currency: 'usd'))
        .thenAnswer((_) async => const Right(null));
    when(() => orderRepository.createOrder(any())).thenAnswer((invocation) async {
      return Right(invocation.positionalArguments.first as Order);
    });

    container.listen(checkoutProvider, (previous, next) {});
    await container.read(checkoutProvider.future);
    container.listen(cartProvider, (previous, next) {});
    await container.read(cartProvider.future);

    final notifier = container.read(checkoutProvider.notifier);
    notifier.selectShipping(ShippingMethod.all.first);
    await notifier.placeOrder();

    final state = container.read(checkoutProvider).value!;
    expect(state.completedOrder, isNotNull);
    expect(state.completedOrder!.total, cart.total + ShippingMethod.all.first.cost);
    expect(state.isPlacingOrder, isFalse);
    verify(() => cartRepository.clearCart()).called(1);
  });

  test('placeOrder surfaces a decline without creating an order or clearing the cart', () async {
    when(() => paymentGateway.pay(amountInSmallestUnit: any(named: 'amountInSmallestUnit'), currency: 'usd'))
        .thenAnswer((_) async => const Left(Failure.payment(message: 'Your card was declined')));

    container.listen(checkoutProvider, (previous, next) {});
    await container.read(checkoutProvider.future);
    container.listen(cartProvider, (previous, next) {});
    await container.read(cartProvider.future);

    final notifier = container.read(checkoutProvider.notifier);
    notifier.selectShipping(ShippingMethod.all.first);
    await notifier.placeOrder();

    final state = container.read(checkoutProvider).value!;
    expect(state.failure, const Failure.payment(message: 'Your card was declined'));
    expect(state.completedOrder, isNull);
    verifyNever(() => orderRepository.createOrder(any()));
    verifyNever(() => cartRepository.clearCart());
  });
}
