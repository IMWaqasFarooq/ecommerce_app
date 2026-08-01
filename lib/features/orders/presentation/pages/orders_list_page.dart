import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/formatting/locale_formatting.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/orders_notifier.dart';
import '../widgets/order_status_badge.dart';

class OrdersListPage extends ConsumerWidget {
  const OrdersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myOrdersTitle)),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(l10n.failedToLoadOrders)),
        data: (orders) {
          if (orders.isEmpty) {
            return Center(child: Text(l10n.noOrdersYet));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: orders.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.orderNumberLabel(order.id.substring(0, 8).toUpperCase())),
                subtitle: Text(
                  '${formatDate(context, order.createdAt)} · ${formatPrice(context, order.total)}',
                ),
                trailing: OrderStatusBadge(status: order.status),
                onTap: () => context.push(RoutePaths.orderDetailPath(order.id)),
              );
            },
          );
        },
      ),
    );
  }
}
