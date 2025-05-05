import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteService {
  final String userId;

  FavoriteService(this.userId) ;
   
  

  

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

    // Fetch each item's data
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

final favoriteItemsCountProvider = FutureProvider<int>((ref) async {
  final favorites = await ref.watch(favoriteProvider).getFavoriteItemsData();
  // print("length: ${favorites.length}"); // Corrected typo
  return favorites.length;
});
