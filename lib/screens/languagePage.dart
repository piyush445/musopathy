import 'package:flutter/material.dart';

import 'package:musopathy/models/data.dart';
import 'package:musopathy/screens/videopage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musopathy/widgets/custom_drawer.dart';
import 'package:musopathy/widgets/upperUI.dart';

import 'package:provider/provider.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final GlobalKey<ScaffoldState> key2 = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key2,
        drawer: CustomDrawer(),
        appBar: AppBar(
          elevation: 0,
          bottomOpacity: 0.0,
          leading: IconButton(
              icon: Icon(Icons.menu),
              iconSize: 30.0,
              color: Theme.of(context).primaryColor,
              onPressed: () => key2.currentState.openDrawer()),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Language',
            style: TextStyle(
              color: Colors.cyan,
              fontFamily: 'Ubuntu',
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    //  mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      UpperUI(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 120),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(14, 81, 102, 1.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 14)),
                              onPressed: () async {
                                Provider.of<Data>(context, listen: false)
                                    .getLanguage("english");

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => VideoPage()));
                              },
                              child: new Text(
                                "English",
                                textAlign: TextAlign
                                    .center, //without alignment the size is according to the text
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.pink.shade900,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 14)),
                              onPressed: () async {
                                Provider.of<Data>(context, listen: false)
                                    .getLanguage("tamil");

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => VideoPage()));
                              },
                              child: new Text(
                                "Tamil",
                                textAlign: TextAlign
                                    .center, //without alignment the size is according to the text
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]))));
  }
}
