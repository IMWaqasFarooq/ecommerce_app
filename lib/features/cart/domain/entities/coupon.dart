import 'package:equatable/equatable.dart';

class Coupon extends Equatable {
  const Coupon({required this.code, required this.discountPercentage});

  final String code;
  final double discountPercentage;

  @override
  List<Object?> get props => [code, discountPercentage];
}
