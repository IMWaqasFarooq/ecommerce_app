import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/address.dart';

Future<Address?> showAddressFormSheet(BuildContext context) {
  return showModalBottomSheet<Address>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _AddressFormSheet(),
  );
}

class _AddressFormSheet extends StatefulWidget {
  const _AddressFormSheet();

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _line1 = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _postalCode = TextEditingController();
  final _country = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    for (final c in [_fullName, _line1, _city, _state, _postalCode, _country, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      Address(
        fullName: _fullName.text.trim(),
        line1: _line1.text.trim(),
        city: _city.text.trim(),
        state: _state.text.trim(),
        postalCode: _postalCode.text.trim(),
        country: _country.text.trim(),
        phone: _phone.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('New address', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              _field(_fullName, 'Full name'),
              _field(_line1, 'Address line'),
              _field(_city, 'City'),
              _field(_state, 'State'),
              _field(_postalCode, 'Postal code'),
              _field(_country, 'Country'),
              _field(_phone, 'Phone', keyboardType: TextInputType.phone),
              const SizedBox(height: AppSpacing.md),
              FilledButton(onPressed: _submit, child: const Text('Save address')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }
}
