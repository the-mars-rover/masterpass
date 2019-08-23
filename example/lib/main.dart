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