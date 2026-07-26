import 'package:equatable/equatable.dart';

class ProductReview extends Equatable {
  const ProductReview({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
  });

  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;

  @override
  List<Object?> get props => [rating, comment, date, reviewerName];
}
