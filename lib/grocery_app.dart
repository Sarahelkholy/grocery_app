import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helpers/constants.dart';
import 'package:grocery_app/core/routing/app_router.dart';
import 'package:grocery_app/core/routing/routes.dart';
import 'package:grocery_app/core/theming/app_text_styles.dart';
import 'package:grocery_app/core/theming/colors.dart';

class GroceryApp extends StatelessWidget {
  final AppRouter appRouter;

  const GroceryApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Grocery app',
          theme: ThemeData(
            primaryColor: ColorsManager.mainYellow,
            scaffoldBackgroundColor: Colors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48.h),

                backgroundColor: ColorsManager.lightYellow,
                disabledBackgroundColor: ColorsManager.lightgray,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                textStyle: AppTextStyles.font16WhiteSemiBold,
              ),
            ),
          ),

          onGenerateRoute: appRouter.generateRoute,
          initialRoute: isLoggedInUser
              ? Routes.homeScreen
              : Routes.onBoardingScreen,
        );
      },
    );
  }
}
