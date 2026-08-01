import 'package:freezed_annotation/freezed_annotation.dart';

import 'failure_code.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.server({required FailureCode code, int? statusCode}) = ServerFailure;

  const factory Failure.network({@Default(FailureCode.network) FailureCode code}) = NetworkFailure;

  const factory Failure.cache({@Default(FailureCode.cache) FailureCode code}) = CacheFailure;

  const factory Failure.unauthorized({@Default(FailureCode.sessionExpired) FailureCode code}) =
      UnauthorizedFailure;

  const factory Failure.validation({required FailureCode code}) = ValidationFailure;

  const factory Failure.payment({required FailureCode code, String? declineCode}) = PaymentFailure;

  const factory Failure.unknown({@Default(FailureCode.unknown) FailureCode code}) = UnknownFailure;
}
