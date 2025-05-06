import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/user/screens/product_detail_screen.dart';
import 'package:e_commerc_app/user/screens/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GridCart extends HookWidget {
  const GridCart({super.key, required this.data});

  final QueryDocumentSnapshot<Object?> data;

  @override
  Widget build(BuildContext context) {
    double? discountPrice;

    useEffect(() {
      if (data['discountPercentage'] != null) {
        final discountPercent = 100 - double.parse(data['discountPercentage']);
        discountPrice = data['price'] * discountPercent / 100;
      }
      return null;
    });
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    ProductDetailScreen(data: data),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              // Simple fade transition (you can customize this)
              const begin = 0.0;
              const end = 1.0;
              var tween = Tween(begin: begin, end: end);
              var fadeAnimation = animation.drive(tween);

              return FadeTransition(opacity: fadeAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      // () => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ProductDetailScreen(data: data),
      //   ),
      // ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.h),
                child: CachedNetworkImage(
                  placeholder:
                      (context, url) => Skeleton(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                  fit: BoxFit.cover,
                  imageUrl: data['image'],
                  width: double.infinity,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            SizedBox(
              height: 33.h,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.h,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: '${data['price']}\$',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 11.h,
                            color: Colors.grey.shade400,
                            decoration:
                                data['isDiscount']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                          ),
                          children: [
                            if (data['isDiscount'])
                              TextSpan(
                                text: '${data['discountPercentage']}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.h,
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
                          return Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 10.h,
                          );
                        }),
                      ),
                      if (data['isDiscount'])
                        Text(
                          "${discountPrice}\$",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 10.h,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
