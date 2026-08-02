import 'dart:math';

import '../../../categories/domain/entities/category.dart';
import '../../../products/domain/entities/product.dart';
import '../entities/product_banner.dart';

typedef CategorySpotlight = ({String category, String label, List<Product> products});

String categoryLabelFor(String category, List<Category> categories) {
  for (final c in categories) {
    if (c.slug == category) return c.name;
  }
  return category
      .split('-')
      .where((w) => w.isNotEmpty)
      .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}

Map<String, List<Product>> groupByCategory(List<Product> products) {
  final byCategory = <String, List<Product>>{};
  for (final product in products) {
    byCategory.putIfAbsent(product.category, () => []).add(product);
  }
  return byCategory;
}

List<ProductBanner> buildDiscountBanners(
  List<Product> pool,
  List<Category> categories, {
  int take = 5,
}) {
  final byCategory = groupByCategory(pool);
  final banners =
      byCategory.entries.map((entry) {
          final products = entry.value;
          final avgDiscount =
              products.map((p) => p.discountPercentage).reduce((a, b) => a + b) /
              products.length;
          final topProduct = products.reduce(
            (a, b) => a.discountPercentage >= b.discountPercentage ? a : b,
          );
          return ProductBanner(
            category: entry.key,
            label: categoryLabelFor(entry.key, categories),
            averageDiscountPercentage: avgDiscount,
            imageUrl: topProduct.thumbnail,
          );
        }).toList()
        ..sort((a, b) => b.averageDiscountPercentage.compareTo(a.averageDiscountPercentage));
  return banners.take(take).toList();
}

List<CategorySpotlight> buildCategorySpotlights(
  List<Product> pool,
  List<Category> categories, {
  int categoryCount = 3,
  int productsPerCategory = 10,
}) {
  final byCategory = groupByCategory(pool);
  final sortedCategories = byCategory.entries.toList()
    ..sort((a, b) => b.value.length.compareTo(a.value.length));

  return sortedCategories.take(categoryCount).map((entry) {
    return (
      category: entry.key,
      label: categoryLabelFor(entry.key, categories),
      products: entry.value.take(productsPerCategory).toList(),
    );
  }).toList();
}

List<Product> topRatedProducts(List<Product> pool, {int take = 12}) {
  final sorted = [...pool]..sort((a, b) => b.rating.compareTo(a.rating));
  return sorted.take(take).toList();
}

List<Product> randomProductSample(List<Product> pool, {int take = 12, Random? random}) {
  final shuffled = [...pool]..shuffle(random);
  return shuffled.take(take).toList();
}
