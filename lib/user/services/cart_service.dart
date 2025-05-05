abstract class CartService {
  Future<void> getAllCart();
  Future<void> saveCartToFireStore();
  Future<void> addToCart(String itemId);
  void removeFromCart(String itemId);
  Future<String> clearCart();
  void updateQuantity(String itemId, int quantity);
}
