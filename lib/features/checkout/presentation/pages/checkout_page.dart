import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure_localization.dart';
import '../../../../core/formatting/locale_formatting.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../cart/presentation/providers/cart_notifier.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/shipping_method.dart';
import '../providers/checkout_notifier.dart';
import '../providers/checkout_state.dart';
import '../utils/shipping_method_l10n.dart';
import '../widgets/address_form_sheet.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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
          ..showSnackBar(SnackBar(content: Text(failure.localizedMessage(context))));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkoutTitle)),
      body: checkoutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(l10n.failedToLoadCheckout)),
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
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(checkoutProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.shippingAddressTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: state.savedAddresses.isEmpty
                ? Center(child: Text(l10n.noSavedAddresses))
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
            label: Text(l10n.addNewAddress),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton(
            onPressed: state.selectedAddress == null ? null : notifier.goToShipping,
            child: Text(l10n.continueToShipping),
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
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(checkoutProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.shippingMethodTitle, style: Theme.of(context).textTheme.titleMedium),
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
                      title: Text(method.localizedLabel(context)),
                      subtitle: Text(localizeDigits(context, l10n.businessDays(method.etaDays))),
                      secondary: Text(formatPrice(context, method.cost)),
                    ),
                ],
              ),
            ),
          ),
          TextButton(onPressed: notifier.goBack, child: Text(l10n.backButton)),
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
    final l10n = AppLocalizations.of(context);
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
          Text(l10n.orderSummaryTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          _row(context, l10n.subtotalLabel, cart.subtotal),
          if (cart.coupon != null) _row(context, l10n.discountLabel, -cart.discount),
          _row(
            context,
            l10n.shippingWithMethod(shipping.localizedLabel(context)),
            shipping.cost,
          ),
          const Divider(),
          _row(context, l10n.totalLabel, total, emphasize: true),
          const Spacer(),
          FilledButton(
            onPressed: state.isPlacingOrder ? null : notifier.placeOrder,
            child: state.isPlacingOrder
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Text(l10n.placeOrder),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: state.isPlacingOrder ? null : notifier.goBack,
            child: Text(l10n.backButton),
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
          Text(formatPrice(context, value), style: style),
        ],
      ),
    );
  }
}
