import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../core/error/failure_code.dart' as core_error;
import '../../../core/error/failures.dart';
import '../domain/repositories/payment_gateway.dart';
import 'datasources/payments_remote_datasource.dart';

class StripePaymentGateway implements PaymentGateway {
  StripePaymentGateway(this._remoteDataSource);
  final PaymentsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, void>> pay({
    required int amountInSmallestUnit,
    required String currency,
  }) async {
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
        return const Left(Failure.payment(code: core_error.FailureCode.paymentCancelled));
      }
      debugPrint('Stripe payment failed: ${e.error.localizedMessage ?? e.error.message}');
      return Left(
        Failure.payment(
          code: core_error.FailureCode.paymentFailed,
          declineCode: e.error.declineCode,
        ),
      );
    } catch (e) {
      debugPrint('Unhandled payment error: $e');
      return const Left(Failure.payment(code: core_error.FailureCode.paymentFailed));
    }
  }
}
