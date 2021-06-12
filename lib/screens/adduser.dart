import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser {
  final String fullName;
  final bool paid;
  final String language;
  final int phno;

  AddUser(this.fullName, this.paid, this.language, this.phno);

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    return users
        .doc(fullName)
        .set({'full_name': fullName,
        "paid":paid,
        "language":language,
        "PhoneNo":phno

        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
