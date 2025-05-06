// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:e_commerc_app/auth/services/auth_service.dart';

class FavoriteItem {
  String itemId;
  FavoriteItem({required this.itemId});
  Map<String, dynamic> toFirestore() {
    return {'itemId': itemId};
  }

  factory FavoriteItem.fromFirestore(Map<String, dynamic> data) {
    return FavoriteItem(itemId: data['itemId'] ?? '');
  }

  @override
  String toString() => 'FavoriteItem(itemId: $itemId)';
}

abstract class FavoriteItemService {}

// Define the StreamNotifier
class FavoriteItemNotifier extends StreamNotifier<List<FavoriteItem>>
    implements FavoriteItemService {
  void add() {
    final items = FavoriteItem(itemId: "djff");
    state = AsyncValue.data([...state.value ?? [], items]);
  }

  @override
  Stream<List<FavoriteItem>> build() async* {
    final firestore = FirebaseFirestore.instance;
    yield [];
  }
}

// Define the StreamNotifierProvider
final favoriteItemProvider =
    StreamNotifierProvider<FavoriteItemNotifier, List<FavoriteItem>>(
      () => FavoriteItemNotifier(),
    );

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
  ref.keepAlive();
  final user = ref.watch(authStateChangesProvider).value;
  return FavoriteService(user!.uid);
});

final favoriteItemsCountProvider = FutureProvider<int>((ref) async {
  final favorites = await ref.watch(favoriteProvider).getFavoriteItemsData();
  // print("length: ${favorites.length}"); // Corrected typo
  return favorites.length;
});
