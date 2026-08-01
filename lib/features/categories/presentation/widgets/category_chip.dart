import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/translation/translated_text.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.translate = true,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool translate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: ChoiceChip(
        label: translate ? TranslatedText(label) : Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: colorScheme.primary,
        labelStyle: TextStyle(color: selected ? colorScheme.onPrimary : colorScheme.onSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.chipRadius)),
      ),
    );
  }
}
