import 'package:flutter/material.dart';
import 'package:musopathy/models/data.dart';
import 'package:musopathy/screens/MyAccount2.dart';
import 'package:musopathy/screens/contact.dart';
import 'package:musopathy/screens/introPage2.dart';
import 'package:musopathy/screens/languagePage.dart';
import 'package:musopathy/screens/loginUi.dart';
import 'package:musopathy/screens/mtbtshow.dart';
import 'package:musopathy/screens/showfaq.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Widget _buildDrawerOption(String title, Function onTap) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 20.0, color: Color.fromRGBO(40, 115, 161, 1.0)),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            // color: Color.fromARGB(100, 69, 155, 174),
            color: Color.fromRGBO(40, 115, 161, 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                    child: Provider.of<Data>(context, listen: false).loggedin ==
                            true
                        ? Text(Provider.of<Data>(context, listen: false)
                            .userName[0])
                        : Image(
                            width: double.infinity,
                            image: AssetImage("assets/images/muso.png"),
                            fit: BoxFit.cover,
                          )),
                Text(
                  "Musopathy",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )
              ],
            ),
          ),
          _buildDrawerOption("Introduction", () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => WebViewExample(),
              ),
            );
          }),
          _buildDrawerOption(
            "MusoPathy & TBt",
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Mtbtshow()),
            ),
          ),
          _buildDrawerOption(
            "Videos",
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => Language(),
              ),
            ),
          ),
          _buildDrawerOption(
            "FAQs",
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ShowFaq(),
              ),
            ),
          ),
          _buildDrawerOption(
            "Contact us",
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ContactScreen(),
              ),
            ),
          ),
          _buildDrawerOption(
            "My Account",
            () => Provider.of<Data>(context, listen: false).loggedin == true
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyAccount2(),
                    ),
                  )
                : Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyHomePage(),
                    ),
                  ),
          ),
          Provider.of<Data>(context).loggedin == true
              ? Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: _buildDrawerOption("Log Out", () {
                    Provider.of<Data>(context, listen: false).logout();
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WebViewExample(),
                      ),
                    );
                  }),
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
    );
  }
}
