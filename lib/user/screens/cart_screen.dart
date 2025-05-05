import 'package:e_commerc_app/user/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CartScreen extends StatefulHookConsumerWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final total = cartItems.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body:
          cartItems.isEmpty
              ? const Center(child: Text('Cart is empty'))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return ListTile(
                          title: Text("${item.name} - id: ${item.productId}"),
                          subtitle: Text('\$${item.price} x ${item.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed:
                                    () => cartNotifier.updateQuantity(
                                      item.productId,
                                      item.quantity - 1,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  cartNotifier.updateQuantity(
                                    item.productId,
                                    item.quantity + 1,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  try {
                                    cartNotifier.removeFromCart(item.productId);
                                  } catch (e) {
                                    throw Exception(e);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Total: \$${total.toStringAsFixed(2)}'),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Place Order'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
