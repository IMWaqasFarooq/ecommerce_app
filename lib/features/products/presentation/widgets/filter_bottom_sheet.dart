import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/product_filter.dart';

const _ratingOptions = [4.0, 3.0, 2.0, 1.0];

Future<ProductFilter?> showFilterBottomSheet(BuildContext context, ProductFilter current) {
  return showModalBottomSheet<ProductFilter>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _FilterBottomSheet(current: current),
  );
}

class _FilterBottomSheet extends StatefulWidget {
  const _FilterBottomSheet({required this.current});

  final ProductFilter current;

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late final _minPriceController = TextEditingController(
    text: widget.current.minPrice?.toStringAsFixed(0) ?? '',
  );
  late final _maxPriceController = TextEditingController(
    text: widget.current.maxPrice?.toStringAsFixed(0) ?? '',
  );
  late double? _minRating = widget.current.minRating;
  late bool _inStockOnly = widget.current.inStockOnly;

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _apply() {
    Navigator.of(context).pop(
      ProductFilter(
        minPrice: double.tryParse(_minPriceController.text),
        maxPrice: double.tryParse(_maxPriceController.text),
        minRating: _minRating,
        inStockOnly: _inStockOnly,
      ),
    );
  }

  void _clear() {
    Navigator.of(context).pop(ProductFilter.empty);
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: AppSpacing.md),
            Text('Price', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Min', prefixText: '\$'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Max', prefixText: '\$'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Minimum rating', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              children: [
                for (final rating in _ratingOptions)
                  ChoiceChip(
                    label: Text('$rating+'),
                    selected: _minRating == rating,
                    onSelected: (selected) => setState(() => _minRating = selected ? rating : null),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('In stock only'),
              value: _inStockOnly,
              onChanged: (value) => setState(() => _inStockOnly = value),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: _clear, child: const Text('Clear all')),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(onPressed: _apply, child: const Text('Apply')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
