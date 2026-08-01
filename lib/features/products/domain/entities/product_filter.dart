import 'package:equatable/equatable.dart';

import 'product.dart';

class ProductFilter extends Equatable {
  const ProductFilter({this.minPrice, this.maxPrice, this.minRating, this.inStockOnly = false});

  static const empty = ProductFilter();

  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool inStockOnly;

  bool get isActive =>
      minPrice != null || maxPrice != null || minRating != null || inStockOnly;

  bool matches(Product product) {
    if (minPrice != null && product.price < minPrice!) return false;
    if (maxPrice != null && product.price > maxPrice!) return false;
    if (minRating != null && product.rating < minRating!) return false;
    if (inStockOnly && !product.inStock) return false;
    return true;
  }

  ProductFilter copyWith({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? inStockOnly,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearMinRating = false,
  }) {
    return ProductFilter(
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      minRating: clearMinRating ? null : (minRating ?? this.minRating),
      inStockOnly: inStockOnly ?? this.inStockOnly,
    );
  }

  @override
  List<Object?> get props => [minPrice, maxPrice, minRating, inStockOnly];
}
