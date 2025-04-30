import 'package:e_commerc_app/components/primary_button.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteScreen extends HookWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14.h,
      children: [
        Text(
          "Favorite Items",
          style: TextStyle(
            color: ThemeData().primaryColor,
            fontSize: 25.h,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            scrollDirection: Axis.vertical,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border(
                    left: BorderSide(width: 5, color: ThemeData().primaryColor),
                  ),
                  boxShadow: [
                    // BoxShadow(
                    //   spreadRadius: 1,
                    //   color: ThemeData().primaryColor.withAlpha(50),
                    //   blurRadius: 1,
                    //   offset: Offset(0, 1),
                    // ),
                  ],
                ),
                child: Row(
                  children: [
                    Row(
                      spacing: 15.h,
                      children: [
                        Container(
                          width: 100.h,
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10.r),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/f3.jpg'),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //spacing: 5.h,
                          children: [
                            Text(
                              "Product Name",
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
                                  "123\$",
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  "12% off",
                                  style: TextStyle(
                                    fontSize: 10.h,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  "12\$",
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
                                PrimaryButton(label: "Add to cart"),
                                PrimaryButton(
                                  label: "Remove",
                                  color: Colors.red,
                                ),
                              ],
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
    );
  }
}
