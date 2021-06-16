<!-- PROJECT LOGO -->
<p align="right">
<a href="https://pub.dev">
<img src="https://raw.githubusercontent.com/born-ideas/masterpass/master/assets/project_badge.png" height="100" alt="Flutter">
</a>
</p>
<p align="center">
<img src="https://raw.githubusercontent.com/born-ideas/masterpass/master/assets/project_logo.png" height="100" alt="Masterpass Example" />
</p>

<!-- PROJECT SHIELDS -->
<p align="center">
<a href="https://pub.dev/packages/masterpass"><img src="https://img.shields.io/pub/v/masterpass" alt="pub"></a>
<a href="https://github.com/born-ideas/masterpass/issues"><img src="https://img.shields.io/github/issues/born-ideas/masterpass" alt="issues"></a>
<a href="https://github.com/born-ideas/masterpass/network"><img src="https://img.shields.io/github/forks/born-ideas/masterpass" alt="forks"></a>
<a href="https://github.com/born-ideas/masterpass/stargazers"><img src="https://img.shields.io/github/stars/born-ideas/masterpass" alt="stars"></a>
<a href="https://dart.dev/guides/language/effective-dart/style"><img src="https://img.shields.io/badge/style-effective_dart-40c4ff.svg" alt="style"></a>
<a href="https://github.com/born-ideas/masterpass/blob/master/LICENSE"><img src="https://img.shields.io/github/license/born-ideas/masterpass" alt="license"></a>
</p>

---
<!-- DEPRECATED WARNING -->
> :warning: **Deprecated**: This plugin is no longer being maintained or supported. Sorry for any inconvenience.

<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
* [Getting Started](#getting-started)
* [Usage](#usage)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)
* [Acknowledgements](#acknowledgements)



<!-- ABOUT THE PROJECT -->
## About The Project
<p align="center">
<img src="https://raw.githubusercontent.com/born-ideas/masterpass/master/assets/screenshot_1.jpeg" width="200" alt="Screenshot 1" />
<img src="https://raw.githubusercontent.com/born-ideas/masterpass/master/assets/screenshot_2.jpeg" width="200" alt="Screenshot 2" />
<img src="https://raw.githubusercontent.com/born-ideas/masterpass/master/assets/screenshot_3.jpeg" width="200" alt="Screenshot 3" />
</p>

[Masterpass](https://masterpass.com/en-za.html) provides a great way to handle in-app card payments on Android and iOS devices.
However, they only provide native iOS and Android libraries to work with their API. This project provides a [Flutter plugin](https://flutter.dev/docs/development/packages-and-plugins)
for working with the masterpass in-app API on both iOS and Android devices.
* The spec for the native android masterpass API can be found [here](https://urldefense.proofpoint.com/v2/url?u=https-3A__oltio.us12.list-2Dmanage.com_track_click-3Fu-3De5edaa7b3cd76ba301db441c6-26id-3Deba8d84ff6-26e-3Db9f08fe4d0&d=DwMFaQ&c=uc5ZRXl8dGLM1RMQwf7xTCjRqXF0jmCF6SP0bDlmMmY&r=ze8BuKzlZostw6sA6oagyZcweugPqDUBG6ZV6PNjUik&m=z7tZfmsqH9tfnlp5O4gl8BMydcup8FyqWTa07nSz6hM&s=G4Lfp2u5PM6Q8ewgfsPqHGctk_4iIYxAPLYZlkYINT8&e=).
* The spec for the native iOS masterpass API can be found [here](https://urldefense.proofpoint.com/v2/url?u=https-3A__oltio.us12.list-2Dmanage.com_track_click-3Fu-3De5edaa7b3cd76ba301db441c6-26id-3D23202bc7dd-26e-3Db9f08fe4d0&d=DwMFaQ&c=uc5ZRXl8dGLM1RMQwf7xTCjRqXF0jmCF6SP0bDlmMmY&r=ze8BuKzlZostw6sA6oagyZcweugPqDUBG6ZV6PNjUik&m=z7tZfmsqH9tfnlp5O4gl8BMydcup8FyqWTa07nSz6hM&s=YcLYcHVcMmpYwY71KRRub2e-a7fcQoBV_klhVkRlCGU&e=).

### Built With
* [Flutter](https://flutter.dev/)
* [Android Jetpack](https://developer.android.com/jetpack/)
* [Swift](https://developer.apple.com/swift/)



<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

Since this is a [Flutter plugin](https://flutter.dev/docs/development/packages-and-plugins), you will need to use it from
within a Flutter App. A few resources to get you started with your first Flutter project:                   
- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

Also, in order to use this plugin, a masterpass merchant account has to be setup on the [Masterpass System](https://developer.mastercard.com/product/masterpass#accept-payments)
After setting up your merchant account, you will receive an API key that you can use for this plugin.

### Installation

Add `masterpass` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

#### iOS

Add the following keys to your Info.plist file, located in `<project root>/ios/Runner/Info.plist`:
```
<key>NSLocationWhenInUseUsageDescription</key>
<string>Your location will be used to prevent fraud.</string>
```

#### Android

No configuration required - the plugin should work out of the box.



<!-- USAGE EXAMPLES -->
## Usage
The example below shows how the plugin can be used. You can test this yourself by using the example app in the [example folder](example).

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

### Response classes

The `checkout` method will return an instance of one of the following
classes which will describe the result:

`InvalidTxnCode` - the transaction code used was invalid.

`MasterpassError` - an error occurred with asterpass before the payment was initiated.

`UserCancelled` - the user cancelled the transaction.

`PaymentFailed` - the payment failed (the `reference` field contains the payment reference)

`PaymentSucceeded` - the payment was successful (the `reference` field contains the payment reference)



<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.



<!-- CONTACT -->
## Contact

BornIdeas - [born.dev](https://www.born.dev) - [info@born.dev](mailto:support@born.dev)

Project Link: [https://github.com/born-ideas/masterpass](https://github.com/born-ideas/masterpass)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [Masterpass by Mastercard](https://masterpass.com/en-za.html)
* [Shields IO](https://shields.io)
* [Open Source Licenses](https://choosealicense.com)
