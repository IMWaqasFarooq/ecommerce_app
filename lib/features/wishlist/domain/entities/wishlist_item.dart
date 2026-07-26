import 'package:equatable/equatable.dart';

class WishlistItem extends Equatable {
  const WishlistItem({
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
  });

  final int productId;
  final String title;
  final String thumbnail;
  final double price;

  @override
  List<Object?> get props => [productId, title, thumbnail, price];
}
