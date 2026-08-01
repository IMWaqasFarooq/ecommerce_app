import 'package:flutter/material.dart';

import '../../../../core/formatting/locale_formatting.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/product.dart';

class PriceTag extends StatelessWidget {
  const PriceTag({required this.product, this.large = false, super.key});

  final Product product;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final priceStyle = large
        ? AppTextStyles.priceLarge(context)
        : AppTextStyles.priceMedium(context);

    if (!product.hasDiscount) {
      return Text(formatPrice(context, product.price), style: priceStyle);
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Text(formatPrice(context, product.discountedPrice), style: priceStyle),
        Text(
          formatPrice(context, product.price),
          style: AppTextStyles.priceStrikethrough(context),
        ),
        if (large)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.discount,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '-${formatDecimal(context, product.discountPercentage.round())}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}
