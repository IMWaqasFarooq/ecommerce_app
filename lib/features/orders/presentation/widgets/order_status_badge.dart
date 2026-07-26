import 'package:flutter/material.dart';

import '../../domain/entities/order_status.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      OrderStatus.processing => ('Processing', scheme.primary),
      OrderStatus.shipped => ('Shipped', scheme.tertiary),
      OrderStatus.delivered => ('Delivered', Colors.green),
      OrderStatus.cancelled => ('Cancelled', scheme.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
