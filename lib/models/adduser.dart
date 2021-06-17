import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser {
  final String email;
  final String fullName;
  final bool paid;

  final int phno;
  String photourl;

  AddUser(this.fullName, this.paid, this.phno, this.email, this.photourl);

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    return users
        .doc(email)
        .set({
          "email": email,
          'full_name': fullName,
          "paid": paid,
          "PhoneNo": phno,
          "photourl": photourl
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
