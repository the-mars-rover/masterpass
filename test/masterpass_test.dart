import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterpass/masterpass.dart';

const String TXN_CODE_FOR_SUCCESS = "txnCodeForSuccess";
const String TXN_CODE_FOR_ERROR = "txnCodeForError";
const String TXN_CODE_FOR_CANCELLED = "txnCodeForCancelled";
const String TXN_CODE_FOR_FAILED = "txnCodeForFailed";
const String TXN_CODE_FOR_INVALID = "txnCodeForInvalid";
const String VALID_TEST_KEY = "validTestKey";
const String VALID_LIVE_KEY = "validLiveKey";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MethodChannel('masterpass')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    return masterpassChannelResponse(methodCall);
  });

  Masterpass masterpass;

  setUp(() {
    masterpass = Masterpass(VALID_TEST_KEY, MasterpassSystem.TEST);
  });

  test("Successful response yields PaymentSucceeded", () async {
    CheckoutResult result = await masterpass.checkout(TXN_CODE_FOR_SUCCESS);
    expectLater(result is PaymentSucceeded, true);
  });

  test("Failed response yields PaymentFailed", () async {
    CheckoutResult result = await masterpass.checkout(TXN_CODE_FOR_FAILED);
    expectLater(result is PaymentFailed, true);
  });

  test("Cancelled response yields UserCancelled", () async {
    CheckoutResult result = await masterpass.checkout(TXN_CODE_FOR_CANCELLED);
    expectLater(result is UserCancelled, true);
  });

  test("Error response yields MasterpassError", () async {
    CheckoutResult result = await masterpass.checkout(TXN_CODE_FOR_ERROR);
    expectLater(result is MasterpassError, true);
  });

  test("Invalid Code response yields InvalidTxnCode", () async {
    CheckoutResult result = await masterpass.checkout(TXN_CODE_FOR_INVALID);
    expectLater(result is InvalidTxnCode, true);
  });
}

Map<String, String> masterpassChannelResponse(MethodCall methodCall) {
  String txnCode = methodCall.arguments["code"];

  switch (txnCode) {
    case TXN_CODE_FOR_SUCCESS:
      return {
        "code": "PAYMENT_SUCCEEDED",
        "reference": "txnReference",
      };
    case TXN_CODE_FOR_ERROR:
      return {
        "code": "OUT_ERROR_CODE",
        "reference": "no ref. for this result",
      };
    case TXN_CODE_FOR_CANCELLED:
      return {
        "code": "USER_CANCELLED",
        "reference": "no ref. for this result",
      };
    case TXN_CODE_FOR_FAILED:
      return {
        "code": "PAYMENT_FAILED",
        "reference": "txnReference",
      };
    default:
      return {
        "code": "INVALID_CODE",
        "reference": "no ref. for this result",
      };
  }
}
