import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product.dart';
import 'product_review_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required int id,
    required String title,
    required String description,
    required String category,
    required double price,
    @Default(0) double discountPercentage,
    @Default(0) double rating,
    @Default(0) int stock,
    String? brand,
    required String thumbnail,
    @Default(<String>[]) List<String> images,
    @Default('In Stock') String availabilityStatus,
    @Default(<ProductReviewModel>[]) List<ProductReviewModel> reviews,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
}

extension ProductModelMapper on ProductModel {
  Product toEntity() => Product(
        id: id,
        title: title,
        description: description,
        category: category,
        price: price,
        discountPercentage: discountPercentage,
        rating: rating,
        stock: stock,
        brand: brand ?? '',
        thumbnail: thumbnail,
        images: images.isEmpty ? [thumbnail] : images,
        availabilityStatus: availabilityStatus,
        reviews: reviews.map((r) => r.toEntity()).toList(),
      );
}
