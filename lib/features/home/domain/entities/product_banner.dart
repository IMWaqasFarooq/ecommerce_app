import 'package:equatable/equatable.dart';

class ProductBanner extends Equatable {
  const ProductBanner({
    required this.category,
    required this.label,
    required this.averageDiscountPercentage,
    required this.imageUrl,
  });

  final String category;
  final String label;
  final double averageDiscountPercentage;
  final String imageUrl;

  @override
  List<Object?> get props => [category, label, averageDiscountPercentage, imageUrl];
}
