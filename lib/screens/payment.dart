import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:musopathy/models/data.dart';
import 'package:musopathy/screens/introPage2.dart';
import 'package:musopathy/screens/videopage.dart';
import 'package:musopathy/widgets/upperUI.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  //  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;
  int amount = 300;
  bool success = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            bottomOpacity: 0.0,
            // leading: IconButton(
            //     icon: Icon(Icons.menu),
            //     iconSize: 30.0,
            //     color: Theme.of(context).primaryColor,
            //     onPressed: () => key2.currentState.openDrawer()),
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              'Payment',
              style: TextStyle(
                color: Colors.cyan,
                fontFamily: 'Ubuntu',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UpperUI(),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: success == false
                    ? Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Container(
                          color: Colors.cyanAccent,
                          height: 200,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Unlock All Premium Content"),
                              Text("One Time Payment"),
                              Text("₹ 300"),
                            ],
                          ),
                        ),
                      )
                    : Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 200,
                      ),
              ),
              RaisedButton(
                onPressed: () async {
                  if (success == true) {
                    await Provider.of<Data>(context, listen: false)
                        .updateUserPayment();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => WebViewExample()));
                  } else {
                    openCheckout();
                  }
                },
                child: success == true
                    ? Text(
                        "move back",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
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
      'name': 'MUSOPATHY',
      'description': 'videos access',
      'prefill': {'contact': '', 'email': ''},
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
    setState(() {
      success = true;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    success = false;
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
