import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toFireStore() {
    return {
      'itemId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromFirestore(Map<String, dynamic> data) {
    return CartItem(
      productId: data['itemId'],
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 1,
    );
  }
}
