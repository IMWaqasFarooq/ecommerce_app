import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/address.dart';
import '../pages/address_map_picker_page.dart';
import '../utils/address_type_l10n.dart';
import 'add_address_method_sheet.dart';

typedef AddressPickerResult = ({Address address, bool isNew});

Future<AddressPickerResult?> showAddressPickerSheet(
  BuildContext context, {
  required List<Address> addresses,
  required Address? selected,
}) {
  return showModalBottomSheet<AddressPickerResult>(
    context: context,
    builder: (context) => _AddressPickerSheet(addresses: addresses, selected: selected),
  );
}

class _AddressPickerSheet extends StatelessWidget {
  const _AddressPickerSheet({required this.addresses, required this.selected});

  final List<Address> addresses;
  final Address? selected;

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
                l10n.shippingAddressTitle,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            for (final address in addresses)
              ListTile(
                leading: Icon(address.type.icon),
                title: Text(address.type.localizedLabel(context)),
                subtitle: Text(address.formatted),
                trailing: address.id == selected?.id ? const Icon(Icons.check_rounded) : null,
                onTap: () => Navigator.of(context).pop((address: address, isNew: false)),
              ),
            ListTile(
              leading: const Icon(Icons.add_rounded),
              title: Text(l10n.addNewAddress),
              onTap: () async {
                final method = await showAddAddressMethodSheet(context);
                if (method == null || !context.mounted) return;
                final address = method == AddAddressMethod.map
                    ? await context.push<Address>(RoutePaths.addressMapPicker)
                    : await context.push<Address>(
                        RoutePaths.addressDetails,
                        extra: const PickedLocation(streetArea: ''),
                      );
                if (address != null && context.mounted) {
                  Navigator.of(context).pop((address: address, isNew: true));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
