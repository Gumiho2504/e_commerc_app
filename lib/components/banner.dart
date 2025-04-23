import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopBanner extends StatelessWidget {
  const TopBanner({super.key});

  void shopNow() {}

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(10.h),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 0.1,
                spreadRadius: 0.1,
                offset: Offset.zero,
              ),
            ],
          ),

          height: 150.h,
          width: screen.width,
        ),
        Positioned(
          right: -30.w,
          bottom: -40.h,
          child: Image.asset(
            "assets/images/girl.png",
            fit: BoxFit.contain,

            width: 200.h,
            height: 150.h,
          ),
        ),
        Positioned(
          left: 40.w,
          top: 20.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Collection",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    "20",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      Text(
                        "%",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "OFF",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              shopNowWiget(),
            ],
          ),
        ),
      ],
    );
  }

  shopNowWiget() {
    return GestureDetector(
      onTap: () {
        shopNow();
      },
      child: Container(
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.h),
        ),
        child: Text(
          "Shop Now",
          style: TextStyle(color: Colors.white, fontSize: 12.h),
        ),
      ),
    );
  }
}
