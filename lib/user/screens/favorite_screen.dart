import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/components/components.dart';
import 'package:e_commerc_app/user/controllers/cart_controller.dart';
import 'package:e_commerc_app/user/models/item.dart';
import 'package:e_commerc_app/user/screens/cart_screen.dart';
import 'package:e_commerc_app/user/screens/product_detail_screen.dart';
import 'package:e_commerc_app/user/screens/skeleton.dart';
import 'package:e_commerc_app/user/services/favorite_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:e_commerc_app/components/primary_button.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteScreen extends HookConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteItems = ref.watch(favoriteItemNotifierProvider);
    final favoriteItemsNotifier = ref.read(
      favoriteItemNotifierProvider.notifier,
    );
    final deleteItem = useCallback((String itemId) {
      favoriteItemsNotifier.removeFavoriteItem(itemId);
    }, [favoriteItems]);

    final addToCart = useCallback((String itemId) async {
      try {
        await ref.read(cartProvider.notifier).addToCart(itemId);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartScreen()),
        );
      } catch (e) {
        throw e;
      }
    });

    //useEffect(() {}, []);
    useAutomaticKeepAlive();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14.h,
      children: [
        headerTitle('My Favorite'),

        favoriteItemsNotifier.isLoading
            ? Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemCount: 6,
                itemBuilder:
                    (context, index) => Skeleton(height: 100, width: 100),
              ),
            )
            : Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                scrollDirection: Axis.vertical,
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  return productCartTail(
                    favoriteItems[index],
                    deleteItem,
                    addToCart,
                    () {
                      final item = favoriteItems[index];

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ProductDetailScreen(
                                item: Item.fromFirestore(item),
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
      ],
    );
  }

  productCartTail(
    Map<String, dynamic> item,
    Function(String) onDelete,
    Function(String) addToCart,
    void Function() action,
  ) {
    double? afterDiscountPrice;
    if (item['isDiscount']) {
      afterDiscountPrice =
          item['price'] -
          ((100 - double.parse(item['discountPercentage'])) / 100);
    }
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10.r),
          border: Border(
            left: BorderSide(width: 5, color: ThemeData().primaryColor),
          ),
        ),
        child: Row(
          children: [
            Row(
              spacing: 15.h,
              children: [
                SizedBox(
                  width: 100.h,
                  height: 100.h,

                  child: Hero(
                    tag: "favorite_to_cart_${item['id']}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: CachedNetworkImage(
                        placeholder:
                            (context, _) => Skeleton(
                              height: double.infinity,
                              width: double.infinity,
                            ),
                        imageUrl: item['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //spacing: 5.h,
                  children: [
                    Text(
                      "${item['name']}",
                      style: TextStyle(
                        fontSize: 18.h,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      spacing: 5.w,
                      children: [
                        Text(
                          "Price :",
                          style: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),

                        Text(
                          "${item['price']}\$",
                          style: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            decoration:
                                item['isDiscount']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                          ),
                        ),
                        if (item['isDiscount'])
                          Text(
                            "${item['discountPercentage']} off",
                            style: TextStyle(
                              fontSize: 10.h,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        if (item['isDiscount'])
                          Text(
                            "$afterDiscountPrice\$",
                            style: TextStyle(
                              fontSize: 14.h,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      spacing: 5.w,
                      children: [
                        InkWell(
                          onTap: () {
                            addToCart(item['id']);
                          },
                          child: PrimaryButton(label: "Add to cart"),
                        ),
                        InkWell(
                          onTap: () {
                            onDelete(item['id']);
                          },
                          child: PrimaryButton(
                            label: "Remove",
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
