import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musopathy/models/data.dart';
import 'package:musopathy/screens/introPage2.dart';

import 'package:musopathy/screens/splashScreen.dart';
import 'package:musopathy/screens/videopage.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _auth = FirebaseAuth.instance;

  Map account = {};
  var user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          user = snapshot.data;
          if (user == null) {
            Provider.of<Data>(context, listen: false).logout();
            return SplashScreen();
          } else if (user != null) {
            Provider.of<Data>(context, listen: false).verify();

            Provider.of<Data>(context, listen: false).login();
            // print(Provider.of<Data>(context, listen: false).language);
            //  Provider.of<Data>(context, listen: false).getLanguage(
            // Provider.of<Data>(context, listen: false).account["language"]);

            return WebViewExample();
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
