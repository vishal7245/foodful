import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodful/resources/storage_methods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //signUp user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    // required double latitude,
    // required double longitude,
    required Uint8List file,
  }) async {
    String res = "Some Error Occurred";
    try {
      if (email == null ||
          password == null ||
          username == null ||
          bio == null) {
        return "Please fill all the fields";
      } else {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profilepics", file, false);
        //adding user to our database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl,
        });
        res = "Signed Up Successfully";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
