import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/payment_method.dart';

extension PaymentMethodL10n on PaymentMethod {
  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      PaymentMethod.card => l10n.paymentMethodCard,
      PaymentMethod.cashOnDelivery => l10n.paymentMethodCashOnDelivery,
    };
  }

  IconData get icon => switch (this) {
    PaymentMethod.card => Icons.credit_card_rounded,
    PaymentMethod.cashOnDelivery => Icons.payments_outlined,
  };
}
