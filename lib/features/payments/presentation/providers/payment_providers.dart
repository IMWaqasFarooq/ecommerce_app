import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/payments_remote_datasource.dart';
import '../../data/stripe_payment_gateway.dart';
import '../../domain/repositories/payment_gateway.dart';
import '../../domain/usecases/pay_usecase.dart';

final paymentsRemoteDataSourceProvider = Provider<PaymentsRemoteDataSource>((ref) {
  return PaymentsRemoteDataSourceImpl(
    ref.watch(dioProvider),
    functionUrl: ref.watch(envConfigProvider).paymentsFunctionUrl,
  );
});

final paymentGatewayProvider = Provider<PaymentGateway>((ref) {
  return StripePaymentGateway(ref.watch(paymentsRemoteDataSourceProvider));
});

final payUseCaseProvider = Provider((ref) => PayUseCase(ref.watch(paymentGatewayProvider)));
