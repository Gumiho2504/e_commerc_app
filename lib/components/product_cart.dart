import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:e_commerc_app/user/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/user/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProductCart extends HookConsumerWidget {
  const ProductCart({super.key, required this.data});
  final QueryDocumentSnapshot data;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userService = ref.watch(userProvider);
    final discountPercent = 100.0 - double.parse(data['discountPercentage']);
    final price = data['price'];
    final discountPrice = price * discountPercent / 100;
    final isFavorite = useState(false);

    Stream<List<Map<String, dynamic>>> favoriteItems =
        userService.getFavoriteItems();

    useEffect(() {
      final subscription = userService.getFavoriteItems().listen((items) {
        final exists = items.any((item) => item['itemId'] == data.id);
        isFavorite.value = exists;
      });
      return subscription.cancel;
    }, [data.id]);

    //final afterDiscountPrice = "9";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(data: data),
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
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20.h),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(data['image']),
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
                            ? await userService.addToFavorite(data.id)
                            : await userService.deleteFavorite(data.id);
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
                  data['name'],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.h),
                ),
                RichText(
                  text: TextSpan(
                    text: '${data['price']}\$',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.h,
                      color: Colors.grey.shade400,
                      decoration: TextDecoration.lineThrough,
                    ),
                    children: [
                      TextSpan(
                        text: '${data['discountPercentage']}%',
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
                Text(
                  "$discountPrice\$",
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
