import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/entities/product_filter.dart';
import 'package:ecommerce_app/features/products/domain/entities/product_review.dart';
import 'package:flutter_test/flutter_test.dart';

Product _product({required double price, required double rating, required int stock}) => Product(
  id: 1,
  title: 'Product',
  description: 'Description',
  category: 'beauty',
  price: price,
  discountPercentage: 0,
  rating: rating,
  stock: stock,
  brand: 'Brand',
  thumbnail: 't',
  images: const [],
  availabilityStatus: 'In Stock',
  reviews: const <ProductReview>[],
);

void main() {
  test('empty filter is not active and matches everything', () {
    expect(ProductFilter.empty.isActive, isFalse);
    expect(ProductFilter.empty.matches(_product(price: 5, rating: 1, stock: 0)), isTrue);
  });

  test('rejects a product below minPrice or above maxPrice', () {
    const filter = ProductFilter(minPrice: 10, maxPrice: 20);

    expect(filter.matches(_product(price: 9.99, rating: 5, stock: 5)), isFalse);
    expect(filter.matches(_product(price: 20.01, rating: 5, stock: 5)), isFalse);
    expect(filter.matches(_product(price: 15, rating: 5, stock: 5)), isTrue);
  });

  test('rejects a product below minRating', () {
    const filter = ProductFilter(minRating: 4);

    expect(filter.matches(_product(price: 5, rating: 3.9, stock: 5)), isFalse);
    expect(filter.matches(_product(price: 5, rating: 4, stock: 5)), isTrue);
  });

  test('inStockOnly rejects out-of-stock products', () {
    const filter = ProductFilter(inStockOnly: true);

    expect(filter.matches(_product(price: 5, rating: 5, stock: 0)), isFalse);
    expect(filter.matches(_product(price: 5, rating: 5, stock: 1)), isTrue);
  });
}
