import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../orders/presentation/providers/order_detail_provider.dart';

class OrderConfirmationPage extends ConsumerWidget {
  const OrderConfirmationPage({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: orderAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => const Text('Order not found'),
              data: (order) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Order placed!', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Order #${order.id.substring(0, 8).toUpperCase()} · \$${order.total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton(
                    onPressed: () => context.go(RoutePaths.home),
                    child: const Text('Continue shopping'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
