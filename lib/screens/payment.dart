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
    return SafeArea(
      child: MaterialApp(
        home: Scaffold(
            // appBar: AppBar(
            //   elevation: 0,
            //   bottomOpacity: 0.0,
            //   centerTitle: true,
            //   backgroundColor: Colors.white,
            //   title: Text(
            //     'Payment',
            //     style: TextStyle(
            //       color: Colors.cyan,
            //       fontFamily: 'Ubuntu',
            //       fontSize: 25,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UpperUI(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: success == false
                  ? Container(
                      height: 150,
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Unlock All Premium Content",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "One Time Payment",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "₹ 300",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(50, 141, 215, 232),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    )
                  : Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 200,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.15,
                height: 55,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: ElevatedButton(
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
                          "Back",
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          "Pay Now",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      primary: Color.fromRGBO(20, 115, 161, 1.0),
                      onPrimary: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Precautions and Disclaimers'),
                          content: Text(
                              "This following sets out the terms and conditions on which you may use the content onbusiness-standard.com website, business-standard.com's mobile browser site, Business Standard instore Applications and other digital publishing services (www.smartinvestor.in, www.bshindi.com and www.bsmotoring,com) owned by Business Standard Private Limited, all the services herein will be referred to as Business Standard Content Services."),
                          actions: [
                            FlatButton(
                              textColor: Colors.black,
                              onPressed: () => Navigator.pop(context),
                              child: Text('Ok'),
                            ),
                            // FlatButton(
                            //   textColor: Colors.black,
                            //   onPressed: () => Navigator.pop(context),
                            //   child: Text('ACCEPT'),
                            // ),
                          ],
                        );
                      },
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text:
                          ' By clicking Pay Now you acknowledge that you have \n read and understood the ',
                      style: TextStyle(color: Colors.cyan),
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'Precautions and Disclaimers',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    ),
                  )),
            ),
          ],
        )),
      ),
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
