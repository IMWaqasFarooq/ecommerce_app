import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/order.dart';
import '../providers/order_detail_provider.dart';
import '../providers/orders_notifier.dart';
import '../widgets/order_status_badge.dart';
import '../widgets/order_tracking_stepper.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: const Text('Order details')),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Order not found')),
        data: (order) => _OrderDetailContent(order: order),
      ),
    );
  }
}

class _OrderDetailContent extends ConsumerWidget {
  const _OrderDetailContent({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order #${order.id.substring(0, 8).toUpperCase()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            OrderStatusBadge(status: order.status),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          DateFormat.yMMMd().add_jm().format(order.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.lg),
        OrderTrackingStepper(status: order.status),
        const SizedBox(height: AppSpacing.lg),
        Text('Items', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        for (final item in order.items)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                  child: CachedNetworkImage(
                    imageUrl: item.thumbnail,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text('${item.title} × ${item.quantity}')),
                Text('\$${item.lineTotal.toStringAsFixed(2)}'),
              ],
            ),
          ),
        const Divider(height: AppSpacing.lg),
        _row(context, 'Subtotal', order.subtotal),
        if (order.discount > 0) _row(context, 'Discount', -order.discount),
        _row(context, 'Shipping (${order.shippingMethodLabel})', order.shippingCost),
        _row(context, 'Total', order.total, emphasize: true),
        const SizedBox(height: AppSpacing.lg),
        Text('Shipping address', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(order.shippingAddressText),
        if (order.isCancellable) ...[
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton(
            onPressed: () async {
              final failure = await ref.read(ordersProvider.notifier).cancelOrder(order.id);
              ref.invalidate(orderDetailProvider(order.id));
              if (failure != null && context.mounted) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(failure.message)));
              }
            },
            child: const Text('Cancel order'),
          ),
        ],
      ],
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
