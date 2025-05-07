import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/user/models/item.dart';
import 'package:e_commerc_app/user/screens/skeleton.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:e_commerc_app/user/services/favorite_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerc_app/user/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProductCart extends HookConsumerWidget {
  const ProductCart({super.key, required this.item});
  final Item item;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userService = ref.watch(favoriteProvider);
    final isFavorite = useState(false);
    final discountPrice = useState<double?>(null);

    useEffect(() {
      final subscription = userService.getFavoriteItems().listen((items) {
        final exists = items.any((item) => item['itemId'] == this.item.id);
        isFavorite.value = exists;
      });
      if (item.isDiscount) {
        final discountPercent = 100 - double.parse(item.discountPercentage!);
        discountPrice.value = item.price * discountPercent / 100;
      }
      return subscription.cancel;
    }, []);

    //final afterDiscountPrice = "9";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(item: item),
          ),
        );
      },
      child: SizedBox(
        height: 270.h,
        width: 200.w,
        child: Column(
          spacing: 6.h,
          children: [
            Stack(
              children: [
                Container(
                  height: 200.h,
                  width: 200.w,
                  padding: EdgeInsets.all(0.h),

                  child: Hero(
                    tag: "_item_${item.id}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.h),
                      child: CachedNetworkImage(
                        placeholder:
                            (context, _) => Skeleton(
                              height: double.infinity,
                              width: double.infinity,
                            ),
                        imageUrl: item.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.h,
                  child: Container(
                    padding: EdgeInsets.all(2.h),
                    height: 30.h,
                    width: 30.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: InkWell(
                      onTap: () async {
                        !isFavorite.value
                            ? await userService.addToFavorite(item.id!)
                            : await userService.deleteFavoriteByItemId(
                              item.id!,
                            );
                        // isFavorite.value = !isFavorite.value;
                      },
                      child: Icon(
                        isFavorite.value
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: isFavorite.value ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.h),
                ),
                RichText(
                  text: TextSpan(
                    text: '${item.price}\$',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.h,
                      color: Colors.grey.shade400,
                      decoration:
                          item.isDiscount
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                    ),
                    children: [
                      if (item.isDiscount)
                        TextSpan(
                          text: '${item.discountPercentage}%',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.h,
                            color: Colors.red.shade400,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(Icons.star, color: Colors.yellow, size: 12.h);
                  }),
                ),
                if (item.isDiscount)
                  Text(
                    "${discountPrice.value}\$",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                      fontSize: 12.h,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
