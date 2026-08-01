import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:ecommerce_app/features/products/data/models/product_review_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const model = ProductModel(
    id: 1,
    title: 'Essence Mascara',
    description: 'A mascara',
    category: 'beauty',
    price: 9.99,
    thumbnail: 't',
    reviews: [
      ProductReviewModel(rating: 5, comment: 'Great', date: '2026-01-01', reviewerName: 'A'),
    ],
  );

  test('toJson produces plain Map/String/num values Hive can store directly', () {
    final json = model.toJson();

    expect(json['reviews'], isA<List<dynamic>>());
    expect(json['reviews'].single, isA<Map<String, dynamic>>());
    expect(json['reviews'].single, isNot(isA<ProductReviewModel>()));
  });

  test('round-trips through toJson/fromJson', () {
    final roundTripped = ProductModel.fromJson(model.toJson());

    expect(roundTripped, model);
  });
}
