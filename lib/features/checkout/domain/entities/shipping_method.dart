import 'package:equatable/equatable.dart';

class ShippingMethod extends Equatable {
  const ShippingMethod({required this.id, required this.cost, required this.etaDays});

  final String id;
  final double cost;
  final int etaDays;

  static const List<ShippingMethod> all = [
    ShippingMethod(id: 'standard', cost: 4.99, etaDays: 5),
    ShippingMethod(id: 'express', cost: 14.99, etaDays: 2),
    ShippingMethod(id: 'overnight', cost: 29.99, etaDays: 1),
  ];

  @override
  List<Object?> get props => [id, cost, etaDays];
}
