import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/formatting/locale_formatting.dart';
import '../../../../core/location/current_position_provider.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/address.dart';
import '../providers/addresses_notifier.dart';
import '../utils/address_type_l10n.dart';
import '../widgets/add_address_method_sheet.dart';
import 'address_map_picker_page.dart';

double? _distanceMeters(double lat, double lng, Address address) {
  final addressLat = address.latitude;
  final addressLng = address.longitude;
  if (addressLat == null || addressLng == null) return null;
  return Geolocator.distanceBetween(lat, lng, addressLat, addressLng);
}

class AddressesPage extends ConsumerWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final addressesAsync = ref.watch(addressesProvider);
    final positionAsync = ref.watch(currentPositionProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myAddressesTitle)),
      body: addressesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(l10n.failedToLoadAddresses)),
        data: (addresses) {
          if (addresses.isEmpty) {
            return Center(child: Text(l10n.noSavedAddresses));
          }

          final position = positionAsync.value;

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: addresses.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final address = addresses[index];
              final meters = position == null
                  ? null
                  : _distanceMeters(position.latitude, position.longitude, address);
              final distance = meters == null ? null : formatDistance(context, meters);
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(address.type.icon),
                title: Row(
                  children: [
                    Text(address.type.localizedLabel(context)),
                    if (distance != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Text(distance, style: AppTextStyles.caption(context)),
                    ],
                  ],
                ),
                subtitle: Text('${address.formatted}\n${address.fullName}, ${address.phone}'),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () => ref.read(addressesProvider.notifier).removeAddress(address),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final method = await showAddAddressMethodSheet(context);
          if (method == null || !context.mounted) return;
          final address = method == AddAddressMethod.map
              ? await context.push<Address>(RoutePaths.addressMapPicker)
              : await context.push<Address>(
                  RoutePaths.addressDetails,
                  extra: const PickedLocation(streetArea: ''),
                );
          if (address != null) {
            await ref.read(addressesProvider.notifier).addAddress(address);
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addAddressButton),
      ),
    );
  }
}
