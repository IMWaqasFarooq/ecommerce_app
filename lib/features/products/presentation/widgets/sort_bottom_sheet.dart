import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/product_sort.dart';
import '../utils/product_sort_l10n.dart';

Future<ProductSort?> showSortBottomSheet(BuildContext context, ProductSort current) {
  return showModalBottomSheet<ProductSort>(
    context: context,
    builder: (context) => _SortBottomSheet(current: current),
  );
}

class _SortBottomSheet extends StatelessWidget {
  const _SortBottomSheet({required this.current});

  final ProductSort current;

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
                l10n.sortByTitle,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            for (final sort in ProductSort.values)
              ListTile(
                title: Text(sort.localizedLabel(context)),
                trailing: sort == current ? const Icon(Icons.check_rounded) : null,
                onTap: () => Navigator.of(context).pop(sort),
              ),
          ],
        ),
      ),
    );
  }
}
