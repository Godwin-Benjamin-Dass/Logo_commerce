import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logo_commerce/Model/userModel.dart';

class UserProvider extends ChangeNotifier {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('User_Bio_Data');

  List<user> _userData = [];
  List<user> get userData => _userData;

  fetchUser() async {
    var dataJson = await _userCollection
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
    final data = dataJson.data() as Map<String, dynamic>;
    _userData.add(user(
        name: data["Name"],
        email: data["Email"],
        phone: data["PhoneNumber"],
        address: data["Address"]));
    notifyListeners();
  }

  updateUser(user user) async {
    _userCollection.doc(FirebaseAuth.instance.currentUser!.email).set({
      "Name": user.name,
      "Email": FirebaseAuth.instance.currentUser!.email,
      "PhoneNumber": user.phone,
      "Address": user.address
    });
    _userData.clear();
    _userData.add(user);
    notifyListeners();
  }
}
