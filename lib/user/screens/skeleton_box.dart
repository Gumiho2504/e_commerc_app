import 'package:e_commerc_app/user/screens/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Skeleton(height: double.infinity, width: double.infinity),
          ),

          SizedBox(height: 5.h),
          SizedBox(
            height: 33.h,
            child: Column(
              spacing: 4.h,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Skeleton(height: 10.h, width: 50.w),
                    Skeleton(height: 10.h, width: 50.w),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Skeleton(height: 10.h, width: 50.w),
                    Skeleton(height: 10.h, width: 50.w),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

