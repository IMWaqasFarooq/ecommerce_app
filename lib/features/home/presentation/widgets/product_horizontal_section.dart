import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/presentation/widgets/product_card.dart';

class ProductHorizontalSection extends StatelessWidget {
  const ProductHorizontalSection({
    required this.title,
    required this.products,
    required this.onViewMore,
    required this.onProductTap,
    super.key,
  });

  final String title;
  final List<Product> products;
  final VoidCallback onViewMore;
  final void Function(Product product) onProductTap;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.sectionTitle(context)),
                TextButton(onPressed: onViewMore, child: Text(l10n.viewMoreAction)),
              ],
            ),
          ),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: products.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final product = products[index];
                return SizedBox(
                  width: 150,
                  child: ProductCard(product: product, onTap: () => onProductTap(product)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
