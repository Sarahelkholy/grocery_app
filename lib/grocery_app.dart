import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/routing/app_router.dart';
import 'package:grocery_app/core/routing/routes.dart';
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
          ),
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: Routes.signUpScreen,
        );
      },
    );
  }
}
