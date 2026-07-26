import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  const CartItem({
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.quantity,
  });

  final int productId;
  final String title;
  final String thumbnail;
  final double price;
  final int quantity;

  double get lineTotal => price * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
    productId: productId,
    title: title,
    thumbnail: thumbnail,
    price: price,
    quantity: quantity ?? this.quantity,
  );

  @override
  List<Object?> get props => [productId, title, thumbnail, price, quantity];
}
