import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../wishlist/presentation/providers/wishlist_notifier.dart';
import '../../domain/entities/product.dart';
import 'price_tag.dart';
import 'rating_stars.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({required this.product, required this.onTap, super.key});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider).value ?? const [];
    final isWishlisted = wishlist.any((item) => item.productId == product.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'product-${product.id}',
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                  if (!product.inStock)
                    Positioned(
                      top: AppSpacing.xs,
                      left: AppSpacing.xs,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Out of stock',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: AppSpacing.xxs,
                    right: AppSpacing.xxs,
                    child: IconButton.filledTonal(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isWishlisted ? Colors.red : null,
                        size: 18,
                      ),
                      onPressed: () => ref
                          .read(wishlistProvider.notifier)
                          .toggle(
                            productId: product.id,
                            title: product.title,
                            thumbnail: product.thumbnail,
                            price: product.price,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  RatingStars(rating: product.rating),
                  const SizedBox(height: AppSpacing.xxs),
                  PriceTag(product: product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
