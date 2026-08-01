import 'package:flutter/widgets.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/order_status.dart';

extension OrderStatusL10n on OrderStatus {
  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      OrderStatus.processing => l10n.statusProcessing,
      OrderStatus.shipped => l10n.statusShipped,
      OrderStatus.delivered => l10n.statusDelivered,
      OrderStatus.cancelled => l10n.statusCancelled,
    };
  }
}
