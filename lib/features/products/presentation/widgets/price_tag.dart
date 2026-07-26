import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/product.dart';

class PriceTag extends StatelessWidget {
  const PriceTag({required this.product, this.large = false, super.key});

  final Product product;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final priceStyle = large ? AppTextStyles.priceLarge(context) : AppTextStyles.priceMedium(context);

    if (!product.hasDiscount) {
      return Text('\$${product.price.toStringAsFixed(2)}', style: priceStyle);
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Text('\$${product.discountedPrice.toStringAsFixed(2)}', style: priceStyle),
        Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.priceStrikethrough(context)),
        if (large)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.discount,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '-${product.discountPercentage.round()}%',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}
