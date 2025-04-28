import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCart extends StatelessWidget {
  const ProductCart({Key? key, required this.data}) : super(key: key);
  final QueryDocumentSnapshot data;
  @override
  Widget build(BuildContext context) {
    final discountPercent = 100.0 - double.parse(data['discountPercentage']);
    final price = data['price'];
    final discountPrice = price * discountPercent / 100;

    //final afterDiscountPrice = "9";

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detail');
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
                    child: Icon(Icons.favorite, color: Colors.red),
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
