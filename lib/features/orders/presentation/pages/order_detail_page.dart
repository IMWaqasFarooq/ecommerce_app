import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure_localization.dart';
import '../../../../core/formatting/locale_formatting.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/translation/translated_text.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../checkout/presentation/utils/shipping_method_l10n.dart';
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
    final l10n = AppLocalizations.of(context);
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderDetailsTitle)),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(l10n.orderNotFound)),
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
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.orderNumberLabel(order.id.substring(0, 8).toUpperCase()),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            OrderStatusBadge(status: order.status),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          formatDateTime(context, order.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.lg),
        OrderTrackingStepper(status: order.status),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.itemsSectionTitle, style: Theme.of(context).textTheme.titleSmall),
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
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: TranslatedText(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      Text(' × ${formatDecimal(context, item.quantity)}'),
                    ],
                  ),
                ),
                Text(formatPrice(context, item.lineTotal)),
              ],
            ),
          ),
        const Divider(height: AppSpacing.lg),
        _row(context, l10n.subtotalLabel, order.subtotal),
        if (order.discount > 0) _row(context, l10n.discountLabel, -order.discount),
        _row(
          context,
          l10n.shippingWithMethod(localizedShippingMethodLabel(context, order.shippingMethodId)),
          order.shippingCost,
        ),
        _row(context, l10n.totalLabel, order.total, emphasize: true),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.shippingAddressSectionTitle, style: Theme.of(context).textTheme.titleSmall),
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
                  ..showSnackBar(SnackBar(content: Text(failure.localizedMessage(context))));
              }
            },
            child: Text(l10n.cancelOrder),
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
          Text(formatPrice(context, value), style: style),
        ],
      ),
    );
  }
}
