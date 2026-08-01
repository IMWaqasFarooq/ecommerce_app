import 'package:flutter/widgets.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/shipping_method.dart';

String localizedShippingMethodLabel(BuildContext context, String id) {
  final l10n = AppLocalizations.of(context);
  return switch (id) {
    'standard' => l10n.shippingStandard,
    'express' => l10n.shippingExpress,
    'overnight' => l10n.shippingOvernight,
    _ => id,
  };
}

extension ShippingMethodL10n on ShippingMethod {
  String localizedLabel(BuildContext context) => localizedShippingMethodLabel(context, id);
}
