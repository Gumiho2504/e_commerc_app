import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

headerTitle(String title) => Text(
  title,
  style: TextStyle(
    color: ThemeData().primaryColor,
    fontSize: 25.h,
    fontWeight: FontWeight.bold,
  ),
);
