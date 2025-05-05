import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/auth/services/auth_service.dart';
import 'package:e_commerc_app/user/models/cart_item.dart';
import 'package:e_commerc_app/user/services/cart_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  return CartNotifier(user!.uid);
});

class CartNotifier extends StateNotifier<List<CartItem>>
    implements CartService {
  String? userId;
  CartNotifier(this.userId) : super([]) {
    getAllCart();
  }

  @override
  Future<void> getAllCart() async {
    if (userId == null) return;
    try {
      final firestore = FirebaseFirestore.instance;
      final doc = await firestore.collection('carts').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final items =
            (doc.data()!['items'] as List<dynamic>)
                .map(
                  (item) =>
                      CartItem.fromFirestore(item as Map<String, dynamic>),
                )
                .toList();
        state = items;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addToCart(String itemsId) async {
    final existedIndex = state.indexWhere((item) => item.productId == itemsId);
    if (existedIndex >= 0) {
      for (int i = 0; i < state.length; i++) {
        if (i == existedIndex) {
          state[i] = CartItem(
            productId: itemsId,
            name: state[i].name,
            price: state[i].price,
            quantity: state[i].quantity + 1,
          );
        }
      }
    } else {
      DocumentSnapshot item =
          await FirebaseFirestore.instance
              .collection('items')
              .doc(itemsId)
              .get();
      state = [
        ...state,
        CartItem(
          productId: itemsId,
          name: item['name'],
          price: item['price'],
          quantity: 1,
        ),
      ];
    }
    saveCartToFireStore();
  }

  @override
  Future<String> clearCart() async {
    state = [];
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('carts').doc(userId).delete();
      return 'success';
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void removeFromCart(String itemId) {
    state = state.where((item) => item.productId != itemId).toList();
    saveCartToFireStore();
  }

  @override
  Future<void> saveCartToFireStore() async {
    if (userId == null) return;
    try {
      await FirebaseFirestore.instance.collection('carts').doc(userId).set({
        'items': state.map((item) => item.toFireStore()).toList(),
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(itemId);
      return;
    }
    state = [
      for (final item in state)
        if (item.productId == itemId)
          CartItem(
            productId: item.productId,
            name: item.name,
            price: item.price,
            quantity: quantity,
          )
        else
          item,
    ];
    saveCartToFireStore();
  }
}
