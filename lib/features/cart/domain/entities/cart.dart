import 'package:equatable/equatable.dart';

import 'cart_item.dart';
import 'coupon.dart';

class Cart extends Equatable {
  const Cart({this.items = const [], this.coupon});

  final List<CartItem> items;
  final Coupon? coupon;

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  double get discount => coupon == null ? 0 : subtotal * (coupon!.discountPercentage / 100);
  double get total => subtotal - discount;

  @override
  List<Object?> get props => [items, coupon];
}
