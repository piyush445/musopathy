import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musopathy/models/data.dart';
import 'package:musopathy/models/adduser.dart';
import 'package:musopathy/screens/Landingpage.dart';
import 'package:musopathy/widgets/BUtton.dart';

import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  Registerwidget createState() => Registerwidget();
}

class Registerwidget extends State<Register> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _emailsignin = TextEditingController();
  TextEditingController _passwordsignin = TextEditingController();
  TextEditingController _username = TextEditingController();
  var _formkey = GlobalKey<FormState>();
  TextEditingController _passwordretype = TextEditingController();
  bool showspinner = false;

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Form(
        key: _formkey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 5, right: 25, bottom: 16),
                child: TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return "enter name";
                    }
                    return null;
                  },
                  controller: _username,
                  decoration: InputDecoration(
                    hintText: "username",
                    labelText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 5, right: 25, bottom: 16),
                child: TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return "enter email";
                    }
                    return null;
                  },
                  controller: _emailsignin,
                  decoration: InputDecoration(
                    hintText: "something@example.com",
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 5, right: 25, bottom: 16),
                child: TextFormField(
                  controller: _passwordsignin,
                  obscureText: true,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "enter password";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Password",
                    labelText: "password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 5, right: 25, bottom: 16),
                child: TextFormField(
                  controller: _passwordretype,
                  obscureText: true,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "enter password";
                    }
                    if (_passwordretype.text != _passwordsignin.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Confirm password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
              ),
              Button(
                "SignUp",
                () async {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  if (_formkey.currentState.validate()) {
                    setState(() {
                      showspinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: _emailsignin.text.trim(),
                              password: _passwordsignin.text.trim());

                      if (newUser != null) {
                        Provider.of<Data>(context, listen: false).login();

                        var user = AddUser(
                            _username.text,
                            false,
                            null,
                            newUser.user.email,
                            newUser.user.photoURL,
                            null,
                            null,
                            null,
                            false);
                        user.addUser();
                        // Provider.of<Data>(context, listen: false).verify();
                        Fluttertoast.showToast(
                            msg: "success", toastLength: Toast.LENGTH_LONG);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LandingPage()));
                        //  print(email);
                      }
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg: "signup failed", toastLength: Toast.LENGTH_LONG);
                      _formkey.currentState.reset();
                    } finally {
                      setState(() {
                        showspinner = false;
                      });
                    }
                  }
                },
              ),
              InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Expanded(
                          child: AlertDialog(
                            title: Text('Terms and Conditions'),
                            content: Text(
                                "This following sets out the terms and conditions on which you may use the content onbusiness-standard.com website, business-standard.com's mobile browser site, Business Standard instore Applications and other digital publishing services (www.smartinvestor.in, www.bshindi.com and www.bsmotoring,com) owned by Business Standard Private Limited, all the services herein will be referred to as Business Standard Content Services."),
                            actions: [
                              TextButton(
                                // textColor: Colors.black,
                                style: ButtonStyle(),
                                onPressed: () => Navigator.pop(context),
                                child: Text('CANCEL'),
                              ),
                              TextButton(
                                // textColor: Colors.black,
                                onPressed: () => Navigator.pop(context),
                                child: Text('ACCEPT'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: ' By signing you agree with our ',
                      style:
                          TextStyle(color: Color.fromRGBO(40, 115, 161, 1.0)),
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
