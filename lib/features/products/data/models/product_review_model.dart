import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_review.dart';

part 'product_review_model.freezed.dart';
part 'product_review_model.g.dart';

@freezed
abstract class ProductReviewModel with _$ProductReviewModel {
  const factory ProductReviewModel({
    required int rating,
    required String comment,
    required String date,
    required String reviewerName,
  }) = _ProductReviewModel;

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewModelFromJson(json);
}

extension ProductReviewModelMapper on ProductReviewModel {
  ProductReview toEntity() => ProductReview(
        rating: rating,
        comment: comment,
        date: DateTime.tryParse(date) ?? DateTime.now(),
        reviewerName: reviewerName,
      );
}
