import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/formatting/locale_formatting.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../orders/presentation/providers/order_detail_provider.dart';

class OrderConfirmationPage extends ConsumerWidget {
  const OrderConfirmationPage({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: orderAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text(l10n.orderNotFound),
              data: (order) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.orderPlaced, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.orderNumberWithTotal(
                      order.id.substring(0, 8).toUpperCase(),
                      formatPrice(context, order.total),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton(
                    onPressed: () => context.go(RoutePaths.home),
                    child: Text(l10n.continueShopping),
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
