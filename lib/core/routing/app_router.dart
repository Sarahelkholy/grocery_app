import 'package:flutter/material.dart';
import 'package:grocery_app/core/routing/routes.dart';
import 'package:grocery_app/features/sign_up/sign_up_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    // this arguments to be passed in any screen like this (arguments as className)
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.signUpScreen:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      default:
        return null;
    }
  }
}
