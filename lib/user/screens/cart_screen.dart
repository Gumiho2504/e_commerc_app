import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/user/controllers/cart_controller.dart';
import 'package:e_commerc_app/user/screens/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 10.w),
        backgroundColor: Colors.white,
        title: Text(
          'My Cart',
          style: TextStyle(
            fontSize: 18.h,
            fontWeight: FontWeight.w600,
            color: ThemeData().primaryColor,
          ),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            GestureDetector(
              onTap: () => cartNotifier.clearCart(),
              child: Text("clear all", style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body:
          cartItems.isEmpty
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Empty',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        Future<String> r = cartNotifier.getProductImage(
                          item.productId,
                        );

                        return Container(
                          padding: EdgeInsets.all(10.h),
                          margin: EdgeInsets.all(10.h),
                          height: 120.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(5.h),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 12.w,
                                children: [
                                  SizedBox(
                                    height: 100.h,
                                    width: 100.h,
                                    child: FutureBuilder(
                                      future: r,
                                      builder: (context, data) {
                                        if (data.data == null) {
                                          return Skeleton(
                                            height: double.infinity,
                                            width: double.infinity,
                                          );
                                        }
                                        String image = data.data!;
                                        return Hero(
                                          tag:
                                              "favorite_to_cart_${item.productId}",
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              5.h,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: TextStyle(
                                          fontSize: 16.h,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "id : ${item.productId}",
                                        style: TextStyle(
                                          fontSize: 8.h,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Price : ${item.price.toString()} \$",
                                        style: TextStyle(
                                          fontSize: 10.h,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Discount : 10%",
                                        style: TextStyle(
                                          fontSize: 10.h,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Quantity : ${item.quantity}",
                                        style: TextStyle(
                                          fontSize: 10.h,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "total : ${item.quantity * item.price}\$",
                                        style: TextStyle(
                                          fontSize: 10.h,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton.filledTonal(
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                    iconSize: 18.h,
                                    onPressed: () {
                                      cartNotifier.removeFromCart(
                                        item.productId,
                                      );
                                    },

                                    icon: Icon(Icons.delete),
                                  ),
                                  Row(
                                    children: [
                                      IconButton.filledTonal(
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.grey.shade200,
                                        ),
                                        iconSize: 16.h,
                                        onPressed: () {
                                          cartNotifier.updateQuantity(
                                            item.productId,
                                            item.quantity - 1,
                                          );
                                        },

                                        icon: Icon(Icons.remove),
                                      ),
                                      IconButton.filledTonal(
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.grey.shade200,
                                        ),
                                        iconSize: 16.h,
                                        onPressed: () {
                                          cartNotifier.updateQuantity(
                                            item.productId,
                                            item.quantity + 1,
                                          );
                                        },

                                        icon: Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

      bottomNavigationBar:
          cartItems.isNotEmpty
              ? Container(
                height: 160.h,
                padding: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                  //color: Colors.grey.shade100,
                  border: Border(
                    top: BorderSide(width: 1, color: Colors.grey.shade400),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total :",
                            style: TextStyle(
                              fontSize: 20.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "$total \$",
                            style: TextStyle(
                              fontSize: 20.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeData().primaryColor,
                            overlayColor: Colors.red,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Order Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Container(height: 0),
    );
  }
}
