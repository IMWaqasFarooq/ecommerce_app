import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/cart_notifier.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/coupon_input.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cartAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Failed to load cart')),
        data: (cart) {
          if (cart.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return CartItemTile(
                      item: item,
                      onIncrement: () => notifier.updateQuantity(item.productId, item.quantity + 1),
                      onDecrement: () => notifier.updateQuantity(item.productId, item.quantity - 1),
                      onRemove: () => notifier.removeItem(item.productId),
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CouponInput(
                        appliedCoupon: cart.coupon,
                        onApply: (code) async {
                          final failure = await notifier.applyCoupon(code);
                          if (failure != null && context.mounted) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(SnackBar(content: Text(failure.message)));
                          }
                        },
                        onRemove: notifier.removeCoupon,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _SummaryRow(label: 'Subtotal', value: cart.subtotal),
                      if (cart.coupon != null) _SummaryRow(label: 'Discount', value: -cart.discount),
                      _SummaryRow(label: 'Total', value: cart.total, emphasize: true),
                      const SizedBox(height: AppSpacing.md),
                      FilledButton(
                        onPressed: () => context.push(RoutePaths.checkout),
                        child: const Text('Proceed to checkout'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.emphasize = false});

  final String label;
  final double value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
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
