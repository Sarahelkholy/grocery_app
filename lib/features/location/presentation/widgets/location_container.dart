// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helpers/constants.dart';
import 'package:grocery_app/core/helpers/extentions.dart';
import 'package:grocery_app/core/helpers/spacing.dart';
import 'package:grocery_app/core/routing/routes.dart';
import 'package:grocery_app/core/theming/app_text_styles.dart';
import 'package:grocery_app/core/theming/colors.dart';
import 'package:grocery_app/features/auth/presentation/provider/auth_provider.dart'
    as my_auth;
import 'package:grocery_app/features/location/presentation/provider/location_provider.dart';
import 'package:grocery_app/main.dart';
import 'package:provider/provider.dart';

class LocationContainer extends StatefulWidget {
  const LocationContainer({super.key, required this.locationData});

  final LocationProvider locationData;

  @override
  State<LocationContainer> createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkIfLoggedInUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.locationData.isLoading)
              LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorsManager.lightYellow,
                ),
                backgroundColor: Colors.grey[200],
              ),
            Text(
              widget.locationData.selectedAddress?.street ??
                  'Loading street...',
              style: AppTextStyles.font16BlackBold,
            ),
            Text(
              widget.locationData.selectedAddress?.locality ??
                  'Loading city...',
              style: AppTextStyles.font14GraySemiBold,
            ),
            Text(
              widget.locationData.selectedAddress?.country ??
                  'Loading country...',
              style: AppTextStyles.font14GraySemiBold,
            ),
            verticalSpace(10),
            AbsorbPointer(
              absorbing: widget.locationData.isLoading ? true : false,
              child: ElevatedButton(
                onPressed: () async {
                  final authProvider = Provider.of<my_auth.AuthProvider>(
                    context,
                    listen: false,
                  );

                  final lat = widget.locationData.latitude;
                  final lng = widget.locationData.longitude;

                  if (lat == null || lng == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Location not ready yet")),
                    );
                    return;
                  }

                  final address =
                      "${widget.locationData.selectedAddress?.street ?? ''}, "
                      "${widget.locationData.selectedAddress?.locality ?? ''}, "
                      "${widget.locationData.selectedAddress?.country ?? ''}";

                  if (!isLoggedInUser) {
                    authProvider.setPendingLocation(
                      lat: lat,
                      lng: lng,
                      address: address,
                    );

                    context.pushReplacementNamed(Routes.loginScreen);
                  } else {
                    await authProvider.updateUserLocation(
                      latitude: lat,
                      longitude: lng,
                      address: address,
                    );
                    context.pushReplacementNamed(Routes.homeScreen);
                  }
                },

                child: Text(
                  'Confirm location',
                  style: AppTextStyles.font16WhiteSemiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
