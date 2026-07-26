import 'package:equatable/equatable.dart';

class ShippingMethod extends Equatable {
  const ShippingMethod({
    required this.id,
    required this.label,
    required this.cost,
    required this.etaDays,
  });

  final String id;
  final String label;
  final double cost;
  final int etaDays;

  static const List<ShippingMethod> all = [
    ShippingMethod(id: 'standard', label: 'Standard shipping', cost: 4.99, etaDays: 5),
    ShippingMethod(id: 'express', label: 'Express shipping', cost: 14.99, etaDays: 2),
    ShippingMethod(id: 'overnight', label: 'Overnight shipping', cost: 29.99, etaDays: 1),
  ];

  @override
  List<Object?> get props => [id, label, cost, etaDays];
}
