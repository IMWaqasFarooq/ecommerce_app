import 'package:flutter/material.dart';

import '../../domain/entities/order_status.dart';
import '../utils/order_status_l10n.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (status) {
      OrderStatus.processing => scheme.primary,
      OrderStatus.shipped => scheme.tertiary,
      OrderStatus.delivered => Colors.green,
      OrderStatus.cancelled => scheme.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.localizedLabel(context),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
