import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Data extends ChangeNotifier {
  bool loggedin;
  String language;
  String currentname;
  String currentUrl;
  String currentdesc;
  String email;
  String userName;
  String photourl;

  List li;
  Map account = {};

  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  void verify() {
    _auth.authStateChanges().listen((User user) async {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        email = user.email;
        print('User is signed in!');
        firestore
            .collection('users')
            .doc(user.email)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            //  print(documentSnapshot.data());
            account = Map.from(documentSnapshot.data());
            photourl = account["photourl"].toString();
            print(photourl);
          } else {
            print("not exist");
          }
        });
      }
    });
    notifyListeners();
  }

  void login() {
    loggedin = true;
    // language = account["language"];
    notifyListeners();
  }

  void logout() {
    loggedin = false;
    notifyListeners();
  }

  void getLanguage(String l) {
    language = l;
    if (language == "english") {
      currentname = "Preparation & Posture ...";
      currentUrl =
          "https://player.vimeo.com/video/562218703?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479";
      currentdesc = "Preparation and Posture..";
    } else if (language == "tamil") {
      currentname = "தயாரிப்பு & நிலை Preparation & Posture";
      currentUrl =
          "https://player.vimeo.com/video/562783946?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479";
      currentdesc = "Preparation and Posture..";
    }
    notifyListeners();
  }

  void fetchVideos(List videos) {
    li = videos;
    notifyListeners();
  }

  void updateCurrentDetails(int index) {
    if (language == "english") {
      currentUrl = li[index]["elink"];
      currentname = li[index]["ename"];
      currentdesc = li[index]["description"];
    } else {
      currentUrl = li[index]["tlink"];
      currentname = li[index]["tname"];
      currentdesc = li[index]["description"];
    }
    notifyListeners();
  }

  updatelanguage() {
    //when logged in
  }
  Future<void> updateUserPayment() {
    return users
        .doc(email)
        .update({'paid': true})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

//   void getCurrentUserDetails() async {
//     User user = _auth.currentUser;
//     if (user != null) {
//       //print(user.displayName);
//       email = user.email;

//       await firestore
//           .collection('users')
//           .doc(user.email)
//           .get()
//           .then((DocumentSnapshot documentSnapshot) {
//         if (documentSnapshot.exists) {
//           //  print(documentSnapshot.data());
//           account = Map.from(documentSnapshot.data());
//           userName = account["name"];
//           print(account);
//           // photourl = account["photourl"].toString();
//           // print(photourl);
//         } else {
//           print("not exist");
//         }
//       });
//     }
//     notifyListeners();
//   }
// }
