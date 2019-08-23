# masterpass

A Flutter plugin for working with the masterpass in-app API.

## Installation

First add `masterpass` to as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### iOS

Add the following keys to your Info.plist file, located in `<project root>/ios/Runner/Info.plist`:
```
<key>NSLocationWhenInUseUsageDescription</key>
<string>Your location will be used to prevent fraud.</string>
```

### Android

No configuration required - the plugin should work out of the box.

## Example

In order to use this plugin, a masterpass merchant account has to be 
setup on the Masterpass system - see https://developer.mastercard.com/product/masterpass#accept-payments
to create a merchant account.

```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:masterpass/masterpass.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  ///The form key to use for the amount form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// The controller for the amount to pay.
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masterpass Example App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _amountField(),
                _payButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the pay button.
  Widget _payButton(context) {
    return RaisedButton(
      child: Text("PAY"),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          //show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => SimpleDialog(
              title: Center(child: CircularProgressIndicator()),
              backgroundColor: Colors.transparent,
            ),
          );

          String txnCode =
              await _getTransactionId(double.parse(_amountController.text));

          String apiKey =
              "enter-your-api-key-here"; // Your masterpass API key.
          String system = MasterpassSystem
              .TEST; // The masterpass system you want to use (TEST or LIVE)
          Masterpass masterpass = Masterpass(apiKey, system);
          CheckoutResult paymentResult = await masterpass.checkout(txnCode);

          if (paymentResult is PaymentSucceeded) {
            bool paymentVerified =
                await _verifyTransaction(txnCode, paymentResult.reference);
            Navigator.of(context).pop(); //pop the loading dialog
            if (paymentVerified) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Payment succeeded."),
              ));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Could not verify payment."),
              ));
            }
          } else {
            Navigator.of(context).pop(); //pop the loading dialog
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Payment failed."),
            ));
          }
        }
      },
    );
  }

  /// Returns the amount field
  TextFormField _amountField() {
    return TextFormField(
      controller: _amountController,
      decoration: InputDecoration(
        labelText: "Amount",
      ),
      validator: (text) {
        try {
          double.parse(text);
        } catch (e) {
          return "Please enter a valid amount";
        }

        return null;
      },
    );
  }

  /// Make a call to your backend to get a code for the transaction.
  Future<String> _getTransactionId(double amount) async {
    //You should replace this code with the call to your backend which requests a new transaction from masterpass.
    return Future.value("sample-transaction-code-from-your-backend");
  }

  /// Make a call to your backend to verify the payment
  Future<bool> _verifyTransaction(String txnCode, String paymentRef) async {
    //You should replace this code with the call to your backend which verifies that the transaction was successful.
    return Future.value(true);
  }
}
```

## Response classes

The `checkout` method will return an instance of one of the following
classes which will describe the result:

`InvalidTxnCode` - the transaction code used was invalid.

`MasterpassError` - an error occurred with asterpass before the payment was initiated.

`UserCancelled` - the user cancelled the transaction.

`PaymentFailed` - the payment failed (the `reference` field contains the payment reference)

`PaymentSucceeded` - the payment was successful (the `reference` field contains the payment reference)

## Additional information:

The spec for the native android masterpass API can be found [here](https://urldefense.proofpoint.com/v2/url?u=https-3A__oltio.us12.list-2Dmanage.com_track_click-3Fu-3De5edaa7b3cd76ba301db441c6-26id-3Deba8d84ff6-26e-3Db9f08fe4d0&d=DwMFaQ&c=uc5ZRXl8dGLM1RMQwf7xTCjRqXF0jmCF6SP0bDlmMmY&r=ze8BuKzlZostw6sA6oagyZcweugPqDUBG6ZV6PNjUik&m=z7tZfmsqH9tfnlp5O4gl8BMydcup8FyqWTa07nSz6hM&s=G4Lfp2u5PM6Q8ewgfsPqHGctk_4iIYxAPLYZlkYINT8&e=)

The spec for the native iOS masterpass API can be found [here](https://urldefense.proofpoint.com/v2/url?u=https-3A__oltio.us12.list-2Dmanage.com_track_click-3Fu-3De5edaa7b3cd76ba301db441c6-26id-3D23202bc7dd-26e-3Db9f08fe4d0&d=DwMFaQ&c=uc5ZRXl8dGLM1RMQwf7xTCjRqXF0jmCF6SP0bDlmMmY&r=ze8BuKzlZostw6sA6oagyZcweugPqDUBG6ZV6PNjUik&m=z7tZfmsqH9tfnlp5O4gl8BMydcup8FyqWTa07nSz6hM&s=YcLYcHVcMmpYwY71KRRub2e-a7fcQoBV_klhVkRlCGU&e=)