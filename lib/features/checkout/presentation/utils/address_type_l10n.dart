import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/address_type.dart';

extension AddressTypeL10n on AddressType {
  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      AddressType.home => l10n.addressTypeHome,
      AddressType.work => l10n.addressTypeWork,
      AddressType.other => l10n.addressTypeOther,
    };
  }

  IconData get icon => switch (this) {
    AddressType.home => Icons.home_rounded,
    AddressType.work => Icons.work_rounded,
    AddressType.other => Icons.location_on_rounded,
  };
}
