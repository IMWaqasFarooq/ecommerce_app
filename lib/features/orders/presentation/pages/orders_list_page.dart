import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/orders_notifier.dart';
import '../widgets/order_status_badge.dart';

class OrdersListPage extends ConsumerWidget {
  const OrdersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Failed to load orders')),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: orders.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Order #${order.id.substring(0, 8).toUpperCase()}'),
                subtitle: Text(
                  '${DateFormat.yMMMd().format(order.createdAt)} · \$${order.total.toStringAsFixed(2)}',
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
