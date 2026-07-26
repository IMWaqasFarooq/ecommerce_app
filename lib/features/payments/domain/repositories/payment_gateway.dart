import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class PaymentGateway {
  Future<Either<Failure, void>> pay({required int amountInSmallestUnit, required String currency});
}
