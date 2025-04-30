import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserService {
  final String userId;
  UserService(this.userId);

  Future<void> addToFavorite(String itemId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(itemId)
          .set({'itemId': itemId, 'createdAt': FieldValue.serverTimestamp()});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteFavorite(String itemId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(itemId)
        .delete();
  }

  Stream<List<Map<String, dynamic>>> getFavoriteItems() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => {...doc.data(), 'id': doc.id})
                  .toList(),
        );
  }
}

final userProvider = Provider<UserService>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  return UserService(user!.uid);
});
