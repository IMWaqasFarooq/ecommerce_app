import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

class SortFilterPill extends StatelessWidget {
  const SortFilterPill({
    required this.filterActive,
    required this.onSort,
    required this.onFilter,
    super.key,
  });

  final bool filterActive;
  final VoidCallback onSort;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.primary,
      elevation: 4,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(999),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PillButton(
            label: l10n.sortLabel,
            icon: Icons.swap_vert_rounded,
            color: scheme.onPrimary,
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(999)),
            onTap: onSort,
          ),
          Container(width: 1, height: 24, color: scheme.onPrimary.withValues(alpha: 0.3)),
          _PillButton(
            label: l10n.filterLabel,
            icon: Icons.tune_rounded,
            color: scheme.onPrimary,
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(999)),
            showBadge: filterActive,
            onTap: onFilter,
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.borderRadius,
    required this.onTap,
    this.showBadge = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final BorderRadius borderRadius;
  final VoidCallback onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(width: 6),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 20),
                if (showBadge)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
