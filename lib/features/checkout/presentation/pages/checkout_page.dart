import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../cart/presentation/providers/cart_notifier.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/shipping_method.dart';
import '../providers/checkout_notifier.dart';
import '../providers/checkout_state.dart';
import '../widgets/address_form_sheet.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutAsync = ref.watch(checkoutProvider);

    ref.listen(checkoutProvider, (previous, next) {
      final order = next.value?.completedOrder;
      if (order != null && previous?.value?.completedOrder == null) {
        context.go(RoutePaths.orderConfirmationPath(order.id));
      }
      final failure = next.value?.failure;
      if (failure != null && previous?.value?.failure == null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(failure.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: checkoutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Failed to load checkout')),
        data: (state) => switch (state.step) {
          CheckoutStep.address => _AddressStep(state: state),
          CheckoutStep.shipping => _ShippingStep(state: state),
          CheckoutStep.payment => _PaymentStep(state: state),
        },
      ),
    );
  }
}

class _AddressStep extends ConsumerWidget {
  const _AddressStep({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(checkoutProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Shipping address', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: state.savedAddresses.isEmpty
                ? const Center(child: Text('No saved addresses yet'))
                : RadioGroup<Address>(
                    groupValue: state.selectedAddress,
                    onChanged: (value) => notifier.selectAddress(value!),
                    child: ListView(
                      children: [
                        for (final address in state.savedAddresses)
                          RadioListTile<Address>(
                            value: address,
                            title: Text(address.fullName),
                            subtitle: Text(address.formatted),
                          ),
                      ],
                    ),
                  ),
          ),
          OutlinedButton.icon(
            onPressed: () async {
              final address = await showAddressFormSheet(context);
              if (address != null) await notifier.addAddress(address);
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add new address'),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton(
            onPressed: state.selectedAddress == null ? null : notifier.goToShipping,
            child: const Text('Continue to shipping'),
          ),
        ],
      ),
    );
  }
}

class _ShippingStep extends ConsumerWidget {
  const _ShippingStep({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(checkoutProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Shipping method', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: RadioGroup<ShippingMethod>(
              groupValue: state.selectedShipping,
              onChanged: (value) => notifier.selectShipping(value!),
              child: ListView(
                children: [
                  for (final method in ShippingMethod.all)
                    RadioListTile<ShippingMethod>(
                      value: method,
                      title: Text(method.label),
                      subtitle: Text(
                        '${method.etaDays} business day${method.etaDays > 1 ? 's' : ''}',
                      ),
                      secondary: Text('\$${method.cost.toStringAsFixed(2)}'),
                    ),
                ],
              ),
            ),
          ),
          TextButton(onPressed: notifier.goBack, child: const Text('Back')),
        ],
      ),
    );
  }
}

class _PaymentStep extends ConsumerWidget {
  const _PaymentStep({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(checkoutProvider.notifier);
    final cart = ref.watch(cartProvider).value;
    final shipping = state.selectedShipping;
    if (cart == null || shipping == null) return const SizedBox.shrink();

    final total = cart.total + shipping.cost;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Order summary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          _row(context, 'Subtotal', cart.subtotal),
          if (cart.coupon != null) _row(context, 'Discount', -cart.discount),
          _row(context, 'Shipping (${shipping.label})', shipping.cost),
          const Divider(),
          _row(context, 'Total', total, emphasize: true),
          const Spacer(),
          FilledButton(
            onPressed: state.isPlacingOrder ? null : notifier.placeOrder,
            child: state.isPlacingOrder
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : const Text('Place order'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: state.isPlacingOrder ? null : notifier.goBack,
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, double value, {bool emphasize = false}) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('\$${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}
