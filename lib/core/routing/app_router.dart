import 'package:flutter/material.dart';
import 'package:grocery_app/core/routing/routes.dart';
import 'package:grocery_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:grocery_app/features/sign_up/sign_up_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    // this arguments to be passed in any screen like this (arguments as className)
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      default:
        return null;
    }
  }
}
