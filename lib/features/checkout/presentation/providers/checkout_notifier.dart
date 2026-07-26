import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../cart/presentation/providers/cart_notifier.dart';
import '../../../orders/domain/entities/order.dart';
import '../../../orders/domain/entities/order_item.dart';
import '../../../orders/domain/entities/order_status.dart';
import '../../../orders/presentation/providers/order_providers.dart';
import '../../../payments/domain/usecases/pay_usecase.dart';
import '../../../payments/presentation/providers/payment_providers.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/shipping_method.dart';
import 'address_providers.dart';
import 'checkout_state.dart';

part 'checkout_notifier.g.dart';

@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
  @override
  Future<CheckoutState> build() async {
    final result = await ref.watch(getSavedAddressesUseCaseProvider)(const NoParams());
    final addresses = result.fold((failure) => <Address>[], (addresses) => addresses);

    final cartTotal = ref.read(cartProvider).value?.total ?? 0;
    await ref.read(analyticsServiceProvider).logBeginCheckout(value: cartTotal);

    return CheckoutState(
      savedAddresses: addresses,
      selectedAddress: addresses.isEmpty ? null : addresses.first,
    );
  }

  void selectAddress(Address address) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedAddress: address));
  }

  Future<void> addAddress(Address address) async {
    final current = state.value;
    if (current == null) return;
    final result = await ref.read(saveAddressUseCaseProvider)(address);
    result.fold((failure) {}, (addresses) {
      state = AsyncData(current.copyWith(savedAddresses: addresses, selectedAddress: address));
    });
  }

  void goToShipping() {
    final current = state.value;
    if (current == null || current.selectedAddress == null) return;
    state = AsyncData(current.copyWith(step: CheckoutStep.shipping));
  }

  void selectShipping(ShippingMethod method) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedShipping: method, step: CheckoutStep.payment));
  }

  void goBack() {
    final current = state.value;
    if (current == null) return;
    final previous = switch (current.step) {
      CheckoutStep.address => CheckoutStep.address,
      CheckoutStep.shipping => CheckoutStep.address,
      CheckoutStep.payment => CheckoutStep.shipping,
    };
    state = AsyncData(current.copyWith(step: previous));
  }

  Future<void> placeOrder() async {
    final current = state.value;
    final address = current?.selectedAddress;
    final shipping = current?.selectedShipping;
    if (current == null || address == null || shipping == null) return;

    final cart = ref.read(cartProvider).value;
    if (cart == null || cart.isEmpty) return;

    state = AsyncData(current.copyWith(isPlacingOrder: true, failure: null));

    final total = cart.total + shipping.cost;
    final payResult = await ref.read(payUseCaseProvider)(
      PayParams(amountInSmallestUnit: (total * 100).round(), currency: 'usd'),
    );

    final failure = payResult.fold((failure) => failure, (_) => null);
    if (failure != null) {
      state = AsyncData(current.copyWith(isPlacingOrder: false, failure: failure));
      return;
    }

    final order = Order(
      id: const Uuid().v4(),
      items: cart.items
          .map(
            (i) => OrderItem(
              productId: i.productId,
              title: i.title,
              thumbnail: i.thumbnail,
              price: i.price,
              quantity: i.quantity,
            ),
          )
          .toList(),
      subtotal: cart.subtotal,
      discount: cart.discount,
      shippingCost: shipping.cost,
      total: total,
      shippingAddressText: address.formatted,
      shippingMethodLabel: shipping.label,
      status: OrderStatus.processing,
      createdAt: DateTime.now(),
    );

    final createResult = await ref.read(createOrderUseCaseProvider)(order);
    await createResult.fold(
      (failure) async =>
          state = AsyncData(current.copyWith(isPlacingOrder: false, failure: failure)),
      (createdOrder) async {
        await ref.read(cartProvider.notifier).clearCart();
        await ref
            .read(analyticsServiceProvider)
            .logPurchase(orderId: createdOrder.id, value: createdOrder.total);
        state = AsyncData(current.copyWith(isPlacingOrder: false, completedOrder: createdOrder));
      },
    );
  }
}
