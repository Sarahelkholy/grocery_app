import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/helpers/extentions.dart';
import 'package:grocery_app/core/helpers/spacing.dart';
import 'package:grocery_app/core/routing/routes.dart';
import 'package:grocery_app/features/home/presentation/widgets/banner_slider.dart';
import 'package:grocery_app/features/home/presentation/widgets/home_app_bar.dart';
import 'package:grocery_app/features/home/presentation/widgets/search_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HomeAppBar(),
            SeaechContainer(),
            verticalSpace(10),
            BannerSlider(),
            Center(
              child: TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  context.pushReplacementNamed(Routes.onBoardingScreen);
                },
                child: Text('Signout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
