import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../providers/addresses_notifier.dart';
import '../widgets/address_form_sheet.dart';

class AddressesPage extends ConsumerWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My addresses')),
      body: addressesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Failed to load addresses')),
        data: (addresses) {
          if (addresses.isEmpty) {
            return const Center(child: Text('No saved addresses yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: addresses.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final address = addresses[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on_outlined),
                title: Text(address.fullName),
                subtitle: Text(address.formatted),
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
          final address = await showAddressFormSheet(context);
          if (address != null) {
            await ref.read(addressesProvider.notifier).addAddress(address);
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add address'),
      ),
    );
  }
}
