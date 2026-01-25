import 'package:flutter/material.dart';
import 'package:grocery_app/core/routing/routes.dart';
import 'package:grocery_app/features/home/presentation/home_screen.dart';
import 'package:grocery_app/features/location/presentation/screens/map_screen.dart';
import 'package:grocery_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:grocery_app/features/auth/presentation/login_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    // this arguments to be passed in any screen like this (arguments as className)
    // final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.mapScreen:
        return MaterialPageRoute(builder: (_) => const MapScreen());

      default:
        return null;
    }
  }
}
