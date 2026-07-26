import 'package:dartz/dartz.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../core/error/failures.dart';
import '../domain/repositories/payment_gateway.dart';
import 'datasources/payments_remote_datasource.dart';

class StripePaymentGateway implements PaymentGateway {
  StripePaymentGateway(this._remoteDataSource);
  final PaymentsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, void>> pay({required int amountInSmallestUnit, required String currency}) async {
    try {
      final clientSecret = await _remoteDataSource.createPaymentIntentClientSecret(
        amountInSmallestUnit: amountInSmallestUnit,
        currency: currency,
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Velora',
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      return const Right(null);
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return const Left(Failure.payment(message: 'Payment was cancelled'));
      }
      return Left(
        Failure.payment(
          message: e.error.localizedMessage ?? e.error.message ?? 'Payment failed',
          declineCode: e.error.declineCode,
        ),
      );
    } catch (e) {
      return Left(Failure.payment(message: e.toString()));
    }
  }
}
