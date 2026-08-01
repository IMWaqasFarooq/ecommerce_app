import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/order_status.dart';
import '../utils/order_status_l10n.dart';

const _trackingSteps = [OrderStatus.processing, OrderStatus.shipped, OrderStatus.delivered];

class OrderTrackingStepper extends StatelessWidget {
  const OrderTrackingStepper({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == OrderStatus.cancelled) {
      return Row(
        children: [
          Icon(Icons.cancel_rounded, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: AppSpacing.sm),
          Text(AppLocalizations.of(context).orderCancelledMessage),
        ],
      );
    }

    final currentIndex = _trackingSteps.indexOf(status);
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        for (var i = 0; i < _trackingSteps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                color: i <= currentIndex ? scheme.primary : scheme.outlineVariant,
              ),
            ),
          Column(
            children: [
              Icon(
                i <= currentIndex ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: i <= currentIndex ? scheme.primary : scheme.outlineVariant,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                _trackingSteps[i].localizedLabel(context),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
