import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserService {
  final String userId;
  UserService(this.userId);

  Future<void> addToFavorite(String itemId) async {
    try {
      await FirebaseFirestore.instance.collection('favorites').doc(itemId).set({
        'itemId': itemId,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteFavorite(String itemId) async {
    await FirebaseFirestore.instance
        .collection('favorites')
        .doc(itemId)
        .delete();
  }

  Stream<List<Map<String, dynamic>>> getFavoriteItems() {
    return FirebaseFirestore.instance
        .collection('favorites')
        .where('userId', isEqualTo: userId)
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
  final user = ref.watch(authStateChangesProvider).value;
  return UserService(user!.uid);
});
