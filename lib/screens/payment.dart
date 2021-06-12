import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  //  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  int amount = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Razorpay Sample App'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LimitedBox(
                maxWidth: 150,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "enter amount"),
                  onChanged: (val) {
                    setState(() {
                      amount = num.parse(val);
                    });
                  },
                ),
              ),
              RaisedButton(
                onPressed: () {
                  openCheckout();
                },
                child: Text(
                  "make Payment",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: Colors.teal,
              )
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_NHgsWGJDPm1A5h',
      'amount': amount * 100,
      'name': 'PIYUSH',
      'description': 'videos access',
      'prefill': {
        'contact': '7488149849',
        'email': 'piyush.nayan062@gmail.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS:  ${response.paymentId}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR:  ${response.code.toString()}  - ${response.message}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET:  ${response.walletName}",
        toastLength: Toast.LENGTH_SHORT);
  }
}
