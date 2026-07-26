import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/cart_item.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    super.key,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            child: CachedNetworkImage(
              imageUrl: item.thumbnail,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    IconButton.outlined(
                      onPressed: onDecrement,
                      icon: const Icon(Icons.remove_rounded, size: 16),
                      visualDensity: VisualDensity.compact,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: Text('${item.quantity}'),
                    ),
                    IconButton.outlined(
                      onPressed: onIncrement,
                      icon: const Icon(Icons.add_rounded, size: 16),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(onPressed: onRemove, icon: const Icon(Icons.delete_outline_rounded)),
        ],
      ),
    );
  }
}
