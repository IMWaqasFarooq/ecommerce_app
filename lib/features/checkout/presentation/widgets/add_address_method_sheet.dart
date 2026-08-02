import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';

enum AddAddressMethod { map, manual }

Future<AddAddressMethod?> showAddAddressMethodSheet(BuildContext context) {
  return showModalBottomSheet<AddAddressMethod>(
    context: context,
    builder: (context) => const _AddAddressMethodSheet(),
  );
}

class _AddAddressMethodSheet extends StatelessWidget {
  const _AddAddressMethodSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              child: Text(
                l10n.addAddressMethodTitle,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined),
              title: Text(l10n.chooseFromMapAction),
              onTap: () => Navigator.of(context).pop(AddAddressMethod.map),
            ),
            ListTile(
              leading: const Icon(Icons.edit_note_rounded),
              title: Text(l10n.enterManuallyAction),
              onTap: () => Navigator.of(context).pop(AddAddressMethod.manual),
            ),
          ],
        ),
      ),
    );
  }
}
