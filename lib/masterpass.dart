import 'dart:async';

import 'package:flutter/services.dart';

class Masterpass {
  //Fields
  static const MethodChannel _channel = const MethodChannel('masterpass');

  /// The masterpass api key
  final String _key;

  /// The masterpass system to connect to
  final String _system;

  //Methods
  /// Constructor
  ///
  /// Parameters:
  ///
  /// * The masterpass api key - This is the API key provided by Masterpass that
  /// will enable the library to be used. This can be found on the Masterpass
  /// Portal under the Lib Lite Tokens menu item.
  ///
  /// * The masterpass system use - This value should be either [Masterpass.TEST_ENVIRONMENT]
  /// or [Masterpass.LIVE_ENVIRONMENT]
  Masterpass(this._key, this._system);

  /// This method invokes a masterpass payment request.
  ///
  /// Before calling this method, a transaction code is needed.
  /// The transaction code should be retrieved as follows:
  /// 1. The app should make a request to its backend system with an amount to be payed
  /// 2. The backend system will call the masterpass API to get the transaction code
  /// 3. The backend system will respond to the app with the transaction code that
  /// can be used for the [checkout] method.
  Future<CheckoutResult> checkout(String txnCode) async {
    final paymentResultHashMap = await _channel.invokeMethod(
      'checkout',
      <String, dynamic>{"code": txnCode, "system": _system, "key": _key},
    );

    return CheckoutResult.fromMap(Map.from(paymentResultHashMap));
  }
}

/// Models a result received from masterpass.
abstract class CheckoutResult {
  CheckoutResult();

  /// Returns a [CheckoutResult] subclass instance based on the result code from [map]
  factory CheckoutResult.fromMap(Map<String, String> map) {
    switch (map["code"]) {
      case "OUT_ERROR_CODE":
        return MasterpassError();
      case "PAYMENT_FAILED":
        return PaymentFailed(map["reference"]);
      case "USER_CANCELLED":
        return UserCancelled();
      case "INVALID_CODE":
        return InvalidTxnCode();
      case "PAYMENT_SUCCEEDED":
        return PaymentSucceeded(map["reference"]);
      default:
        return null;
    }
  }
}

/// Models a [CheckoutResult] when the transaction code was invalid.
class InvalidTxnCode extends CheckoutResult {}

/// Models a [CheckoutResult] when an error occurred before the payment was started.
class MasterpassError extends CheckoutResult {}

/// Models a [CheckoutResult] when the user cancelled the payment.
class UserCancelled extends CheckoutResult {}

/// Models a [CheckoutResult] when the payment completed unsuccessfully.
class PaymentFailed extends CheckoutResult {
  /// The [reference] for the unsuccessful payment.
  final String reference;

  PaymentFailed(this.reference);
}

/// Models a [CheckoutResult] when the payment completed successfully.
class PaymentSucceeded extends CheckoutResult {
  /// The [reference] for the successful payment.
  final String reference;

  PaymentSucceeded(this.reference);
}

class MasterpassSystem {
  /// The string representing the masterpass test backend environment.
  static const String TEST = "Test";

  /// The String representing the masterpass live backend environment.
  static const String LIVE = "Live";
}
