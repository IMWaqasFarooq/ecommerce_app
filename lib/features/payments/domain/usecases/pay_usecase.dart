import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/payment_gateway.dart';

class PayUseCase implements UseCase<void, PayParams> {
  PayUseCase(this._gateway);
  final PaymentGateway _gateway;

  @override
  Future<Either<Failure, void>> call(PayParams params) =>
      _gateway.pay(amountInSmallestUnit: params.amountInSmallestUnit, currency: params.currency);
}

class PayParams extends Equatable {
  const PayParams({required this.amountInSmallestUnit, required this.currency});

  final int amountInSmallestUnit;
  final String currency;

  @override
  List<Object?> get props => [amountInSmallestUnit, currency];
}
