import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodful/resources/storage_methods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //signUp user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required double latitude,
    required double longitude,
    required Uint8List file,
  }) async {
    String res = "Some Error Occurred";
    try {
      if (email == null ||
          password == null ||
          username == null ||
          bio == null ||
          latitude == null ||
          longitude == null) {
        return "Please fill all the fields";
      } else {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profilepics", file, false);
        //adding user to our database

        model.User user = model.User(
          email: email,
          username: username,
          uid: cred.user!.uid,
          bio: bio,
          followers: [],
          following: [],
          latitude: latitude,
          longitude: longitude,
          photoUrl: photoUrl,
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "Signed Up Successfully";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some Error Occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Logged In Successfully";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
