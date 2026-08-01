import 'package:flutter/widgets.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/product_sort.dart';

extension ProductSortL10n on ProductSort {
  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      ProductSort.featured => l10n.sortFeatured,
      ProductSort.priceLowToHigh => l10n.sortPriceLowToHigh,
      ProductSort.priceHighToLow => l10n.sortPriceHighToLow,
      ProductSort.ratingHighToLow => l10n.sortRatingHighToLow,
      ProductSort.titleAZ => l10n.sortNameAZ,
    };
  }
}
