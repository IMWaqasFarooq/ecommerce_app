import 'package:ecommerce_app/features/categories/domain/entities/category.dart';
import 'package:ecommerce_app/features/home/domain/services/home_curation.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/entities/product_review.dart';
import 'package:flutter_test/flutter_test.dart';

Product _product({
  required int id,
  required String category,
  double discountPercentage = 0,
  double rating = 0,
  String thumbnail = 't',
}) => Product(
  id: id,
  title: 'Product $id',
  description: 'Description',
  category: category,
  price: 10,
  discountPercentage: discountPercentage,
  rating: rating,
  stock: 5,
  brand: 'Brand',
  thumbnail: thumbnail,
  images: const [],
  availabilityStatus: 'In Stock',
  reviews: const <ProductReview>[],
);

void main() {
  const categories = [Category(slug: 'beauty', name: 'Beauty'), Category(slug: 'furniture', name: 'Furniture')];

  group('categoryLabelFor', () {
    test('returns the matching category name', () {
      expect(categoryLabelFor('beauty', categories), 'Beauty');
    });

    test('falls back to title-casing an unknown slug', () {
      expect(categoryLabelFor('mens-shirts', categories), 'Mens Shirts');
    });
  });

  group('groupByCategory', () {
    test('groups products by their category field', () {
      final products = [
        _product(id: 1, category: 'beauty'),
        _product(id: 2, category: 'furniture'),
        _product(id: 3, category: 'beauty'),
      ];

      final grouped = groupByCategory(products);

      expect(grouped.keys, containsAll(['beauty', 'furniture']));
      expect(grouped['beauty']!.map((p) => p.id), [1, 3]);
      expect(grouped['furniture']!.map((p) => p.id), [2]);
    });
  });

  group('buildDiscountBanners', () {
    test('sorts categories by average discount descending and picks the top product image', () {
      final products = [
        _product(id: 1, category: 'beauty', discountPercentage: 10, thumbnail: 'beauty-low'),
        _product(id: 2, category: 'beauty', discountPercentage: 20, thumbnail: 'beauty-high'),
        _product(id: 3, category: 'furniture', discountPercentage: 50, thumbnail: 'furniture-only'),
      ];

      final banners = buildDiscountBanners(products, categories);

      expect(banners.first.category, 'furniture');
      expect(banners.first.averageDiscountPercentage, 50);
      expect(banners.first.imageUrl, 'furniture-only');
      expect(banners.last.category, 'beauty');
      expect(banners.last.averageDiscountPercentage, 15);
      expect(banners.last.imageUrl, 'beauty-high');
    });

    test('respects the take limit', () {
      final products = [
        for (var i = 0; i < 8; i++) _product(id: i, category: 'cat-$i', discountPercentage: i.toDouble()),
      ];

      final banners = buildDiscountBanners(products, const [], take: 3);

      expect(banners, hasLength(3));
    });
  });

  group('buildCategorySpotlights', () {
    test('picks categories with the most products, capped per category', () {
      final products = [
        for (var i = 0; i < 5; i++) _product(id: i, category: 'beauty'),
        for (var i = 5; i < 7; i++) _product(id: i, category: 'furniture'),
        _product(id: 7, category: 'groceries'),
      ];

      final spotlights = buildCategorySpotlights(
        products,
        categories,
        categoryCount: 2,
        productsPerCategory: 3,
      );

      expect(spotlights, hasLength(2));
      expect(spotlights.first.category, 'beauty');
      expect(spotlights.first.products, hasLength(3));
      expect(spotlights[1].category, 'furniture');
    });
  });

  group('topRatedProducts', () {
    test('sorts by rating descending and respects take', () {
      final products = [
        _product(id: 1, category: 'beauty', rating: 3),
        _product(id: 2, category: 'beauty', rating: 4.8),
        _product(id: 3, category: 'beauty', rating: 4),
      ];

      final result = topRatedProducts(products, take: 2);

      expect(result.map((p) => p.id), [2, 3]);
    });
  });

  group('randomProductSample', () {
    test('returns a sample of the requested size drawn from the pool', () {
      final products = [for (var i = 0; i < 10; i++) _product(id: i, category: 'beauty')];

      final result = randomProductSample(products, take: 4);

      expect(result, hasLength(4));
      expect(products.map((p) => p.id), containsAll(result.map((p) => p.id)));
    });
  });
}
