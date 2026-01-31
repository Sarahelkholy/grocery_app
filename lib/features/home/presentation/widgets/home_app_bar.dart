import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helpers/constants.dart';
import 'package:grocery_app/core/helpers/extentions.dart';
import 'package:grocery_app/core/helpers/shared_pref_helper.dart';
import 'package:grocery_app/core/helpers/spacing.dart';
import 'package:grocery_app/core/routing/routes.dart';
import 'package:grocery_app/core/theming/app_text_styles.dart';
import 'package:grocery_app/core/theming/colors.dart';
import 'package:grocery_app/features/location/presentation/provider/location_provider.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  String location = '';
  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final savedLocation = await SharedPrefHelper.getString(
      SharedPrefKeys.userlocation,
    );
    if (mounted) {
      setState(() {
        location = savedLocation ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to GoGrocer',
                  style: AppTextStyles.font16BlackBold,
                ),
                verticalSpace(5),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          locationData.isLoading = true;
                        });
                        await locationData.fetchCurrentLocation();

                        if (locationData.permissionAllowed == true) {
                          context.pushReplacementNamed(Routes.mapScreen);
                          setState(() {
                            locationData.isLoading = false;
                          });
                        } else {
                          log('Location permission not granted');
                        }
                      },
                      child: Icon(
                        Icons.edit_location_outlined,
                        size: 20.sp,
                        color: ColorsManager.darkYellow,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Text(
                        location.isNotEmpty ? location : 'Location not set',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font14GraySemiBold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          horizontalSpace(50),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none,
              size: 26.sp,
              color: ColorsManager.darkYellow,
            ),
          ),
        ],
      ),
    );
  }
}
