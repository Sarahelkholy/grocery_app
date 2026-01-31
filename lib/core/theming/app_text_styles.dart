import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/theming/app_font_weight_helper.dart';
import 'package:grocery_app/core/theming/colors.dart';

class AppTextStyles {
  static TextStyle font24BlackBold = TextStyle(
    color: Colors.black,
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font16GraySemiBold = TextStyle(
    color: ColorsManager.gray,
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
  );

  static TextStyle font15GrayRegular = TextStyle(
    color: ColorsManager.gray,
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.regular,
  );

  static TextStyle font14GraySemiBold = TextStyle(
    color: ColorsManager.gray,
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
  );

  static TextStyle font16WhiteSemiBold = TextStyle(
    color: Colors.white,
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
  );

  static TextStyle font16BlackBold = TextStyle(
    color: Colors.black,
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.bold,
  );
}
