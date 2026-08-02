import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../orders/domain/entities/order.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/shipping_method.dart';

part 'checkout_state.freezed.dart';

@freezed
abstract class CheckoutState with _$CheckoutState {
  const factory CheckoutState({
    @Default(<Address>[]) List<Address> savedAddresses,
    Address? selectedAddress,
    ShippingMethod? selectedShipping,
    @Default(PaymentMethod.card) PaymentMethod selectedPaymentMethod,
    @Default(false) bool isPlacingOrder,
    Failure? failure,
    Order? completedOrder,
  }) = _CheckoutState;
}
