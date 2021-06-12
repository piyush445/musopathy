import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:musopathy/screens/languagePage.dart';
import 'package:musopathy/screens/videopage.dart';
import 'adduser.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  bool showspinner = false;
  String email = "";
  String password = "";
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown,
        appBar: AppBar(
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () {},
                icon: Icon(Icons.person),
                label: Text("Sign up")),
          ],
          backgroundColor: Colors.brown.shade500,
          elevation: 0.0,
          title: Text("sign up to Brew Crew"),
        ),
        body: ModalProgressHUD(
            inAsyncCall: showspinner,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: formkey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          validator: (val) =>
                              val.isEmpty ? "enter an email" : null,
                          onChanged: (val) {
                            email = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          validator: (val) => val.length < 6
                              ? "enter an email 6 chars+ long"
                              : null,
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          onPressed: () async {
                            setState(() {
                              showspinner = true;
                            });
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);

                              if (newUser != null) {
                                var user = AddUser(
                                    "piyush", true, "english", 7050818912);
                                user.addUser();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Language()));
                                print(email);
                              }
                              setState(() {
                                showspinner = false;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          color: Colors.pink[400],
                          child: Text(
                            "sign up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )))));
  }
}
