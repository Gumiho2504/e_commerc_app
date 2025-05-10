// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:e_commerc_app/auth/services/auth_service.dart';



class FavoriteService {
  final String userId;

  FavoriteService(this.userId);

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
    await getFavoriteItemsData();
  }

  Future<void> deleteFavoriteByItemId(String itemId) async {
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

  Future<List<Map<String, dynamic>>> getFavoriteItemsData() async {
    List<Map<String, dynamic>> items = [];

    // Get favorite item IDs
    final favoritesSnapshot =
        await FirebaseFirestore.instance
            .collection('favorites')
            .where('userId', isEqualTo: userId)
            .get();

    final favoriteItemsIds =
        favoritesSnapshot.docs.map((doc) => doc['itemId'] as String).toList();

    for (String itemId in favoriteItemsIds) {
      final itemSnapshot =
          await FirebaseFirestore.instance
              .collection('items')
              .doc(itemId)
              .get();

      if (itemSnapshot.exists) {
        var itemData = itemSnapshot.data()!;
        itemData['id'] = itemId; // Add the itemId to the data map
        items.add(itemData); // Add to the items list
      }
    }

    return items;
  }
}

final favoriteProvider = Provider<FavoriteService>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  return FavoriteService(user!.uid);
});

final favoriteItemNotifierProvider =
    StateNotifierProvider<FavoriteNotifier, List<Map<String, dynamic>>>((ref) {
      return FavoriteNotifier(ref.watch(favoriteProvider));
    });

class FavoriteNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final FavoriteService favoriteService;
  FavoriteNotifier(this.favoriteService) : super([]) {
    getFavoriteItem();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getFavoriteItem() async {
    _isLoading = true;
    state = await favoriteService.getFavoriteItemsData();
    _isLoading = false;
  }

  Future<void> addToFavorite(String itemId) async {
    await favoriteService.addToFavorite(itemId);
    state = await favoriteService.getFavoriteItemsData();
  }

  Future<void> removeFavoriteItem(String itemId) async {
    await favoriteService.deleteFavoriteByItemId(itemId);
    state = await favoriteService.getFavoriteItemsData();
  }

  bool isYourFavoriteItem(String itemId) {
    return state.any((map) => map['id'] == itemId);
  }
}
