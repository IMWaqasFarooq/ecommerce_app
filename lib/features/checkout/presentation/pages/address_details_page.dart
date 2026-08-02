import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../authentication/presentation/providers/auth_state_provider.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/address_type.dart';
import '../utils/address_type_l10n.dart';
import 'address_map_picker_page.dart';

class AddressDetailsPage extends ConsumerStatefulWidget {
  const AddressDetailsPage({required this.picked, super.key});

  final PickedLocation picked;

  @override
  ConsumerState<AddressDetailsPage> createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends ConsumerState<AddressDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late final _apartmentController = TextEditingController(
    text: widget.picked.existing?.apartmentOrVilla ?? '',
  );
  late final _buildingController = TextEditingController(
    text: widget.picked.existing?.buildingOrCluster ?? '',
  );
  late final _directionsController = TextEditingController(
    text: widget.picked.existing?.directions ?? '',
  );
  late final _nicknameController = TextEditingController(
    text: widget.picked.existing?.nickname ?? '',
  );
  late final _fullNameController = TextEditingController(
    text: widget.picked.existing?.fullName ?? ref.read(authStateProvider).value?.displayName ?? '',
  );
  late final _phoneController = TextEditingController(text: widget.picked.existing?.phone ?? '');
  late final _streetAreaController = TextEditingController(text: widget.picked.streetArea);
  late AddressType _type = widget.picked.existing?.type ?? AddressType.home;

  @override
  void dispose() {
    _apartmentController.dispose();
    _buildingController.dispose();
    _directionsController.dispose();
    _nicknameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _streetAreaController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final address = Address(
      id: widget.picked.existing?.id ?? const Uuid().v4(),
      type: _type,
      streetArea: widget.picked.isFromMap
          ? widget.picked.streetArea
          : _streetAreaController.text.trim(),
      latitude: widget.picked.latitude,
      longitude: widget.picked.longitude,
      apartmentOrVilla: _apartmentController.text.trim(),
      buildingOrCluster: _buildingController.text.trim(),
      directions: _directionsController.text.trim(),
      nickname: _nicknameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    context.pop(address);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addressDetailsTitle)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: widget.picked.isFromMap
                    ? Row(
                        children: [
                          Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              widget.picked.streetArea,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(l10n.editAction),
                          ),
                        ],
                      )
                    : TextFormField(
                        controller: _streetAreaController,
                        decoration: InputDecoration(
                          labelText: l10n.streetAreaLabel,
                          prefixIcon: const Icon(Icons.location_on_outlined),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty) ? l10n.required : null,
                      ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  for (final type in AddressType.values)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: ChoiceChip(
                        avatar: Icon(type.icon, size: 18),
                        label: Text(type.localizedLabel(context)),
                        selected: _type == type,
                        onSelected: (_) => setState(() => _type = type),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _apartmentController,
                decoration: InputDecoration(labelText: l10n.apartmentVillaLabel),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? l10n.required : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _buildingController,
                decoration: InputDecoration(labelText: l10n.buildingClusterLabel),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _directionsController,
                decoration: InputDecoration(labelText: l10n.directionsOptionalLabel),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: l10n.nicknameOptionalLabel),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.receiverDetailsLabel, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: l10n.fullNameLabel),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? l10n.required : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: l10n.phoneLabel),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? l10n.required : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(onPressed: _save, child: Text(l10n.saveAddress)),
            ],
          ),
        ),
      ),
    );
  }
}
