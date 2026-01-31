import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/theming/app_text_styles.dart';
import 'package:grocery_app/core/theming/colors.dart';

class SeaechContainer extends StatelessWidget {
  const SeaechContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
      child: TextField(
        onTapOutside: ((event) {
          FocusScope.of(context).unfocus();
        }),
        cursorColor: ColorsManager.gray,
        decoration: InputDecoration(
          hintText: 'Search here...',
          filled: true,
          fillColor: ColorsManager.lightergray,
          hintStyle: AppTextStyles.font15GrayRegular,
          suffixIcon: Icon(
            Icons.search,
            color: ColorsManager.gray,
            size: 24.sp,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
