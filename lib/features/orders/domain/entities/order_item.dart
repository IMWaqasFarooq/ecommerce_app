import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  const OrderItem({
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

  @override
  List<Object?> get props => [productId, title, thumbnail, price, quantity];
}
