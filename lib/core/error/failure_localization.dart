import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';
import 'failure_code.dart';
import 'failures.dart';

extension FailureLocalization on Failure {
  String localizedMessage(BuildContext context) => code.localize(context);
}

extension FailureCodeLocalization on FailureCode {
  String localize(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      FailureCode.network => l10n.errorNetwork,
      FailureCode.networkTimeout => l10n.errorNetworkTimeout,
      FailureCode.networkInsecureConnection => l10n.errorNetworkInsecureConnection,
      FailureCode.networkNoCachedData => l10n.errorNetworkNoCachedData,
      FailureCode.cache => l10n.errorCache,
      FailureCode.sessionExpired => l10n.errorSessionExpired,
      FailureCode.requestCancelled => l10n.errorRequestCancelled,
      FailureCode.rateLimitExceeded => l10n.errorRateLimitExceeded,
      FailureCode.serverUnavailable => l10n.errorServerUnavailable,
      FailureCode.server => l10n.errorServer,
      FailureCode.unknown => l10n.somethingWentWrong,
      FailureCode.orderNotFound => l10n.orderNotFound,
      FailureCode.validationNameRequired => l10n.errorValidationNameRequired,
      FailureCode.validationEmailInvalid => l10n.errorValidationEmailInvalid,
      FailureCode.validationPasswordTooShort => l10n.errorValidationPasswordTooShort,
      FailureCode.validationInvalidCoupon => l10n.errorValidationInvalidCoupon,
      FailureCode.validationOrderNotCancellable => l10n.errorValidationOrderNotCancellable,
      FailureCode.paymentCancelled => l10n.errorPaymentCancelled,
      FailureCode.paymentFailed => l10n.errorPaymentFailed,
      FailureCode.authCancelled => l10n.errorAuthCancelled,
      FailureCode.authGoogleFailed => l10n.errorAuthGoogleFailed,
      FailureCode.authAppleFailed => l10n.errorAuthAppleFailed,
      FailureCode.authUserNotFound => l10n.errorAuthUserNotFound,
      FailureCode.authWrongPassword => l10n.errorAuthWrongPassword,
      FailureCode.authEmailInUse => l10n.errorAuthEmailInUse,
      FailureCode.authWeakPassword => l10n.errorAuthWeakPassword,
      FailureCode.authInvalidEmail => l10n.errorValidationEmailInvalid,
      FailureCode.authUserDisabled => l10n.errorAuthUserDisabled,
      FailureCode.authTooManyRequests => l10n.errorAuthTooManyRequests,
      FailureCode.authNetworkRequestFailed => l10n.errorAuthNetworkRequestFailed,
      FailureCode.authGeneric => l10n.errorAuthGeneric,
    };
  }
}
