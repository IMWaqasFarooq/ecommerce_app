import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure_localization.dart';
import '../../../../core/formatting/locale_formatting.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translation/translated_text.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../cart/domain/entities/cart.dart';
import '../../../cart/presentation/providers/cart_notifier.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/shipping_method.dart';
import '../providers/checkout_notifier.dart';
import '../providers/checkout_state.dart';
import '../utils/payment_method_l10n.dart';
import '../utils/shipping_method_l10n.dart';
import '../widgets/address_picker_sheet.dart';
import '../widgets/slide_to_confirm_button.dart';

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
        data: (state) => _CheckoutContent(state: state),
      ),
    );
  }
}

class _CheckoutContent extends ConsumerWidget {
  const _CheckoutContent({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider).value;
    if (cart == null) return const SizedBox.shrink();

    final shipping = state.selectedShipping;
    final total = cart.total + (shipping?.cost ?? 0);
    final canPlaceOrder =
        state.selectedAddress != null && shipping != null && !cart.isEmpty && !state.isPlacingOrder;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _AddressCard(state: state),
              const SizedBox(height: AppSpacing.md),
              _ItemsAndShippingCard(state: state, cart: cart),
              const SizedBox(height: AppSpacing.md),
              _PaymentMethodCard(state: state),
              const SizedBox(height: AppSpacing.md),
              _PaymentSummaryCard(cart: cart, shipping: shipping, total: total),
            ],
          ),
        ),
        _CheckoutBottomBar(cart: cart, total: total, canPlaceOrder: canPlaceOrder),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: child,
    );
  }
}

class _AddressCard extends ConsumerWidget {
  const _AddressCard({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(checkoutProvider.notifier);
    final address = state.selectedAddress;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.shippingAddressTitle, style: AppTextStyles.sectionTitle(context)),
              TextButton(
                onPressed: () async {
                  final result = await showAddressPickerSheet(
                    context,
                    addresses: state.savedAddresses,
                    selected: state.selectedAddress,
                  );
                  if (result == null) return;
                  if (result.isNew) {
                    await notifier.addAddress(result.address);
                  } else {
                    notifier.selectAddress(result.address);
                  }
                },
                child: Text(l10n.changeAddressAction),
              ),
            ],
          ),
          if (address == null)
            Text(l10n.noSavedAddresses)
          else ...[
            Text(
              address.fullName,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(address.formatted, style: AppTextStyles.caption(context)),
            const SizedBox(height: AppSpacing.xxs),
            Text(address.phone, style: AppTextStyles.caption(context)),
          ],
        ],
      ),
    );
  }
}

class _ItemsAndShippingCard extends ConsumerWidget {
  const _ItemsAndShippingCard({required this.state, required this.cart});

  final CheckoutState state;
  final Cart cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(checkoutProvider.notifier);

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.itemsSectionTitle, style: AppTextStyles.sectionTitle(context)),
          const SizedBox(height: AppSpacing.sm),
          for (final item in cart.items)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.xs),
                    child: CachedNetworkImage(
                      imageUrl: item.thumbnail,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TranslatedText(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  Text('×${formatDecimal(context, item.quantity)}', style: AppTextStyles.caption(context)),
                  const SizedBox(width: AppSpacing.sm),
                  Text(formatPrice(context, item.lineTotal)),
                ],
              ),
            ),
          const Divider(height: AppSpacing.lg),
          Text(l10n.shippingMethodTitle, style: AppTextStyles.sectionTitle(context)),
          RadioGroup<ShippingMethod>(
            groupValue: state.selectedShipping,
            onChanged: (value) => notifier.selectShipping(value!),
            child: Column(
              children: [
                for (final method in ShippingMethod.all)
                  RadioListTile<ShippingMethod>(
                    contentPadding: EdgeInsets.zero,
                    value: method,
                    title: Text(method.localizedLabel(context)),
                    subtitle: Text(localizeDigits(context, l10n.businessDays(method.etaDays))),
                    secondary: Text(formatPrice(context, method.cost)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends ConsumerWidget {
  const _PaymentMethodCard({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(checkoutProvider.notifier);

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.payWithTitle, style: AppTextStyles.sectionTitle(context)),
          RadioGroup<PaymentMethod>(
            groupValue: state.selectedPaymentMethod,
            onChanged: (value) => notifier.selectPaymentMethod(value!),
            child: Column(
              children: [
                for (final method in PaymentMethod.values)
                  RadioListTile<PaymentMethod>(
                    contentPadding: EdgeInsets.zero,
                    value: method,
                    secondary: Icon(method.icon),
                    title: Text(method.localizedLabel(context)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSummaryCard extends StatelessWidget {
  const _PaymentSummaryCard({required this.cart, required this.shipping, required this.total});

  final Cart cart;
  final ShippingMethod? shipping;
  final double total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.orderSummaryTitle, style: AppTextStyles.sectionTitle(context)),
          const SizedBox(height: AppSpacing.sm),
          _row(context, l10n.subtotalLabel, cart.subtotal),
          if (cart.coupon != null) _row(context, l10n.discountLabel, -cart.discount),
          if (shipping != null)
            _row(
              context,
              l10n.shippingWithMethod(shipping!.localizedLabel(context)),
              shipping!.cost,
            ),
          const Divider(),
          _row(context, l10n.totalLabel, total, emphasize: true),
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

class _CheckoutBottomBar extends ConsumerWidget {
  const _CheckoutBottomBar({required this.cart, required this.total, required this.canPlaceOrder});

  final Cart cart;
  final double total;
  final bool canPlaceOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(checkoutProvider.notifier);
    final isPlacingOrder = ref.watch(
      checkoutProvider.select((async) => async.value?.isPlacingOrder ?? false),
    );

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizeDigits(context, l10n.itemsCount(cart.itemCount)),
                  style: AppTextStyles.caption(context),
                ),
                Text(formatPrice(context, total), style: AppTextStyles.priceMedium(context)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            SlideToConfirmButton(
              label: l10n.slideToPlaceOrder,
              enabled: canPlaceOrder,
              isLoading: isPlacingOrder,
              onConfirm: notifier.placeOrder,
            ),
          ],
        ),
      ),
    );
  }
}
