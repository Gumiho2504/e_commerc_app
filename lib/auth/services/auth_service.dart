import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/user/models/user.dart' as user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  AuthService({required this.firebaseAuth, required this.firestore});

  Future<String> getUserRole() async {
    final userDoc =
        await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .get();
    if (userDoc.exists) {
      return userDoc['role'];
    }
    return "";
  }

  Future<String>? signUp(
    String name,
    String email,
    String password,
    user.Role role,
  ) async {
    try {
      //UserCredential userCredential =
      await firebaseAuth.createUserWithEmailAndPassword(
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
      DocumentSnapshot userDoc =
          await firestore
              .collection('users')
              .doc(firebaseAuth.currentUser!.uid)
              .get();
      return userDoc['role'];
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

// Providers
final authRepositoryProvider = Provider<AuthService>((ref) {
  return AuthService(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});


final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
