import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zoom_clone_tutorial/utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();
  User get user => _auth.currentUser!;

  Future<bool> signIn(BuildContext context, String email, String pass) async {
    bool res = false;
    try {
      var result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      print(user);
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': user.displayName,
          'uid': user,
          'profilePhoto': user.photoURL,
        });
      }
      res = true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      res = false;
    }
    return res;
  }

  Future<bool> signUp(BuildContext context, String email, String pass) async {
    bool res = false;
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      print(result);
      print(user);
      if (user != null) {
        // if (userCredential.additionalUserInfo!.isNewUser) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': user.displayName,
          'uid': user,
          'profilePhoto': user.photoURL,
        });
      }
      res = true;
      // }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      res = false;
    }
    return res;
  }

  void signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
