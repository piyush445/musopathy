import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musopathy/models/data.dart';
import 'package:musopathy/screens/languagePage.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  SignInwidget createState() => SignInwidget();
}

class SignInwidget extends State<SignIn> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  var key = GlobalKey<FormState>();
  bool showspinner = false;
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Form(
        key: key,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 16, right: 25, bottom: 16),
                child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val.isEmpty) {
                        return "enter email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintText: "something@example.com")),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 20, right: 25, bottom: 16),
                child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "enter password";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: "password"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.15,
                  height: 55,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        showspinner = true;
                      });
                      if (key.currentState.validate()) {
                        try {
                          final newUser =
                              await _auth.signInWithEmailAndPassword(
                                  email: _email.text.trim(),
                                  password: _password.text.trim());

                          if (newUser != null) {
                            Provider.of<Data>(context, listen: false).login();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => Language()));
                            //  print(email);
                          }
                          setState(() {
                            showspinner = false;
                          });
                        } catch (e) {
                          print(e);
                        }
                      }
                      key.currentState.reset();
                    },
                    child: Text(
                      "Sign In",
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        primary: Color.fromRGBO(40, 115, 161, 1.0),
                        onPrimary: Colors.white),
                  ),
                ),
              ),
              Center(
                child: Text("or Login with"),
              ),
              InkWell(
                onTap: () {},
                child: Ink(
                  padding: EdgeInsets.all(6),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/google_logo.png"),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
