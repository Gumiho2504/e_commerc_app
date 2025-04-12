import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String>? signUp(
    String name,
    String email,
    String password,
    Role role,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set({'name': name.trim(), 'email': email.trim(), 'role': role.name});

      return 'success';
    } on FirebaseAuthException catch (e) {
      return getErrorMessaga(e.code);
    } catch (e) {
      rethrow;
    }
  }

  Future<String>? signIn(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // DocumentSnapshot userDoc =
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      return 'success';
    } on FirebaseAuthException catch (e) {
      return getErrorMessaga(e.code);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw e;
    }
  }

  String getErrorMessaga(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Invalid email provided. Please try again.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-credential':
        return 'Invalid credential provided for that user.';
      default:
        return 'Login failed. Please try again.';
    }
  }
}
